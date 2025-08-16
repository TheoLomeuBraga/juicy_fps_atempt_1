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


func _ready() -> void:
	super()
	dash_charges = max_dash_charges

@export_category("Air Jump")
@export var max_air_jump_charges : int = 0
@export var air_jump_charges : float

func air_estate(delta: float) -> void:
	if is_on_floor():
		air_jump_charges = max_air_jump_charges
	
	super(delta)
	
	if Input.is_action_just_pressed("jump") and air_jump_charges >= 1.0:
		velocity.y = jump_velocity
		air_jump_charges -= 1.0


func _physics_process(delta: float) -> void:
	super(delta)
	
	dash_charges += delta / dash_cool_down
	if dash_charges > max_dash_charges:
		dash_charges = max_dash_charges
	
	if Input.is_action_just_released("dash") and dash_charges >= 1.0:
		dash()
