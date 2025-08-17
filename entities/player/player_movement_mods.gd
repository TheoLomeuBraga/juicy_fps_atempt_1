extends PlayerMovement
class_name PlayerMovementMods

@export_category("Dash")
@export var max_dash_charges : int = 1
@export var dash_charges : float
@export var dash_cool_down : float = 2.0
@export var dash_speed : float = 20.0

func dash() -> void:
	var dir  : Vector3 = get_desired_direction()
	if dir == Vector3.ZERO:
		return
	
	dir = dir.normalized() * dash_speed
	velocity.x = dir.x
	velocity.z = dir.z
	move_and_slide()
	dash_charges -= 1.0
	
	$PlayerSounds/dash.play()


func _ready() -> void:
	super()
	dash_charges = max_dash_charges

@export_category("Air Jump")
@export var max_air_jump_charges : int = 0
var air_jump_charges : float

@export var max_wall_jump_charges : int = 1
var wall_jump_charges : float

func air_estate(delta: float) -> void:
	if is_on_floor():
		air_jump_charges = max_air_jump_charges
	
	super(delta)
	
	if Input.is_action_just_pressed("jump") and air_jump_charges >= 1.0:
		jump()
		air_jump_charges -= 1.0
	
	if jump_buffer > 0 and wall_jump_charges >= 1.0 and is_on_wall_only():
		if get_wall_normal().dot(basis.z) > 0:
			jump(jump_velocity*2)
		else:
			jump(jump_velocity)
			var new_velocity : Vector3 = basis.z * speed * 3
			velocity.x = -new_velocity.x
			velocity.z = -new_velocity.z
		
		air_jump_charges -= 1.0
	
	if Input.is_action_just_released("dash") and dash_charges >= 1.0:
		dash()


func _physics_process(delta: float) -> void:
	super(delta)
	
	dash_charges += delta / dash_cool_down
	if dash_charges > max_dash_charges:
		dash_charges = max_dash_charges
	
	
	
	if estate == PlayerEstateType.FLOOR:
		wall_jump_charges = max_wall_jump_charges
	
	
