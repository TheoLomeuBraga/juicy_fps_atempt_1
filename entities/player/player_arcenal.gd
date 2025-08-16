extends PlayerMovementMods
class_name PlayerArcenal


func _ready() -> void:
	super()

func _input(event) -> void:
	super(event)


func _process(delta: float) -> void:
	super(delta)


@onready var muzle : Node3D = $Muzle
@onready var muzle_animator : AnimationPlayer = $Muzle/AnimationPlayer

const shotgun_cooldown : float = 1.1333
var shot_cool_down : float = 0.0
func _physics_process(delta: float) -> void:
	super(delta)
	
	shot_cool_down -= delta
	
	if Input.is_action_pressed("shot"):
		
		$Muzle/MuzleSounds/BaseShot.pitch_range = Vector2(0.5,1.5)
		
		model.transition_estate = FPSCharterModel.TransitionEstates.SHOT_AUTO
		muzle_animator.play("muzle_shot",-1,1.25)
	
	if Input.is_action_just_released("shot"):
		model.transition_estate = FPSCharterModel.TransitionEstates.NONE
	
	if Input.is_action_just_pressed("alt_shot") and shot_cool_down < 0.0:
		
		$Muzle/MuzleSounds/BaseShot.pitch_range = Vector2(0.4,0.5)
		
		model.punp_shot()
		shot_cool_down = shotgun_cooldown
		muzle_animator.play("muzle_shot",-1,0.8)
		
		
	
	
	
