extends ShapeCast3D
class_name BaseBullet

@export var damage_info : DamageInfo

@export var speed : float = 5.0
@export var max_distance : float = 100.0

var original_pos : Vector3

func _ready() -> void:
	original_pos = global_position


func _physics_process(delta: float) -> void:
	
	if original_pos.distance_to(global_position) > max_distance:
		queue_free()
