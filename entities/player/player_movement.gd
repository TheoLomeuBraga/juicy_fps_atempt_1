extends CharacterBody3D
class_name PlayerMovement

enum PlayerEstateType { NONE, FLOOR, AIR }

var estate : PlayerEstateType = PlayerEstateType.AIR

@export_category("Camera")
@export var mouse_sensitivity : float = 0.01
@export var joystick_sensitivity : float = 0.1
#@export_range(5.0,175.0) var fov : float = 90
#@export_range(5.0,175.0) var gun_fov : float = 90

@export_category("Floor Movement")
@export var speed : float = 5.0
@export var jump_velocity : float = 4.5
@export_range(0.0,10.0) var friction : float = 10
@export_range(0.0,1.0) var jump_buffer_time : float = 0.2

@export_category("Air Movement")
enum AirMovementType { NONE, FULL, PARTIAL }
@export var air_movement_type : AirMovementType = AirMovementType.NONE
@export_range(0.0,10.0) var air_movement_control : float = 1.0

@onready var camera : Camera3D = $Camera3D

@onready var model : FPSCharterModel = $SubViewportContainer/SubViewport/Camera3D/first_person_charter

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	model.walk_speed = 1.0
	model.walk_influence = 0.0
	model.walk_sway_influence = 0.5



func fix_camera_rotation() -> void:
	if camera.rotation_degrees.x < -90:
		camera.rotation_degrees.x = -90
	if camera.rotation_degrees.x > 90:
		camera.rotation_degrees.x = 90

func _input(event)  -> void:
	if event is InputEventMouseMotion:
		var joystick_camera_rotation : Vector2 = event.relative * mouse_sensitivity
		camera.rotation.x -= joystick_camera_rotation.y
		rotation.y -= joystick_camera_rotation.x

func _process(delta: float) -> void:
	
	var joystick_camera_rotation : Vector2 = Input.get_vector("look_left", "look_right","look_up", "look_down") * joystick_sensitivity
	camera.rotation.x -= joystick_camera_rotation.y
	rotation.y -= joystick_camera_rotation.x
	
	fix_camera_rotation()

func get_desired_direction() -> Vector3:
	var input_direction : Vector3 = Vector3(Input.get_axis("left", "right"),0,Input.get_axis("up", "down"))
	var dir : Vector3 = (input_direction.x * basis.x) + (input_direction.z * basis.z)
	if dir.length() > 1:
		dir = dir.normalized()
	return dir

var jump_buffer : float = 0.0
func floor_estate(delta: float) -> void:
	if not is_on_floor():
		estate = PlayerEstateType.AIR
		return
	
	if jump_buffer > 0:
		velocity.y = jump_velocity
		jump_buffer = 0
		model.transition_estate = FPSCharterModel.TransitionEstates.JUMP
	
	var desired_direction : Vector3 = get_desired_direction()
	var direction : Vector3 = desired_direction * speed
	direction.y = velocity.y
	velocity = velocity.move_toward(direction,speed * delta * friction)
	
	if desired_direction == Vector3.ZERO:
		model.transition_estate = FPSCharterModel.TransitionEstates.IDLE
	model.walk_influence = move_toward(model.walk_influence,desired_direction.length(),delta * 3.0)
	model.walk_sway_direction = move_toward(model.walk_sway_direction,Input.get_axis("left","right"),delta * 2.0)
	

func air_estate(delta: float) -> void:
	
	if is_on_floor():
		estate = PlayerEstateType.FLOOR
		model.transition_estate = FPSCharterModel.TransitionEstates.FALL
		
		return
	
	velocity += get_gravity() * delta
	
	var desired_direction : Vector3 = get_desired_direction()
	
	if desired_direction == Vector3.ZERO:
		return
	
	match air_movement_type:
		AirMovementType.FULL:
			var direction : Vector3 = desired_direction * speed
			direction.y = velocity.y
			velocity = velocity.move_toward(direction,speed * delta * air_movement_control)
			
		AirMovementType.PARTIAL:
			var air_inpulse_direction : Vector3 = velocity
			air_inpulse_direction.y = 0.0
			
			
			
			if air_inpulse_direction.normalized().dot(desired_direction) > 0.0 and velocity.length() >= speed:
				var velocity_length : float = velocity.length()
				
				var new_velocity : Vector3
				
				new_velocity = velocity.move_toward(desired_direction * speed,speed * delta * air_movement_control * 2)
				new_velocity = new_velocity.normalized() * velocity_length
				
				velocity.x = new_velocity.x
				velocity.z = new_velocity.z
				
			else:
				desired_direction *= speed
				desired_direction.y = velocity.y
				velocity = velocity.move_toward(desired_direction,speed * delta * air_movement_control)


func _physics_process(delta: float) -> void:
	
	jump_buffer -= delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_time
	
	match estate:
		PlayerEstateType.FLOOR:
			floor_estate(delta)
		PlayerEstateType.AIR:
			air_estate(delta)
	
	move_and_slide()
