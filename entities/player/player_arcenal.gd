extends PlayerMovementMods
class_name PlayerArcenal

@export var bullet_scene : PackedScene

var rng : RandomNumberGenerator

func _ready() -> void:
	super()
	rng = RandomNumberGenerator.new()



@onready var muzle : Node3D = $Muzle
@onready var muzle_animator : AnimationPlayer = $Muzle/AnimationPlayer

const shotgun_cooldown : float = 1.1333
const machinegun_cooldown : float = 0.1
const machinegun_animation_speed : float = 1.25
var shot_cool_down : float = 0.0

func spawn_bullet() -> BaseBullet:
	var bullet : BaseBullet = bullet_scene.instantiate()
	bullet.top_level = true
	add_child(bullet)
	bullet.look_at(camera.global_basis.z)
	bullet.global_position = camera.global_position
	bullet.global_position += camera.global_basis.z * -0.5
	bullet.add_exception(self)
	bullet.set_muzle_position(muzle)
	return bullet

func _physics_process(delta: float) -> void:
	super(delta)
	
	shot_cool_down -= delta
	
	if Input.is_action_pressed("shot") and shot_cool_down < 0.0:
		
		$Muzle/MuzleSounds/BaseShot.pitch_range = Vector2(0.5,1.5)
		
		model.transition_estate = FPSCharterModel.TransitionEstates.SHOT_AUTO
		muzle_animator.play("muzle_shot",-1,machinegun_animation_speed)
		
		spawn_bullet()
		
		shot_cool_down = machinegun_cooldown
	
	if Input.is_action_just_released("shot"):
		model.transition_estate = FPSCharterModel.TransitionEstates.NONE
		
	
	if Input.is_action_pressed("alt_shot") and shot_cool_down < 0.0:
		
		$Muzle/MuzleSounds/BaseShot.pitch_range = Vector2(0.4,0.5)
		
		model.punp_shot()
		muzle_animator.play("muzle_shot",-1,0.8)
		
		for i in range(0,12):
			var bullet : BaseBullet = spawn_bullet()
			bullet.rotation_degrees.x += rng.randf_range(-10.0,10.0)
			bullet.rotation_degrees.y += rng.randf_range(-10.0,10.0)
		
		shot_cool_down = shotgun_cooldown
	
	
	
