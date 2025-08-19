extends ShapeCast3D
class_name BaseBullet

@export var damage_info : DamageInfo

@export var speed : float = 5.0
@export var max_distance : float = 100.0

var original_pos : Vector3

@export var display_model : Node3D

func _ready() -> void:
	original_pos = global_position

@export var destroy_on_wall_contact : bool = true
@export var destroy_on_enemy_contact : bool = true

func _physics_process(delta: float) -> void:
	
	global_position += basis.z * speed * delta
	
	for i in get_collision_count():
		var has_damaged : bool = CharterStats.deal_damage_to(get_collider(i),damage_info)
		if destroy_on_wall_contact and not has_damaged:
			queue_free()
		if destroy_on_enemy_contact and has_damaged:
			queue_free()
	
	if original_pos.distance_to(global_position) > max_distance:
		queue_free()

var tween : Tween
func set_muzle_position(muzle : Node3D) -> void:
	if display_model == null:
		return
	display_model.global_position = muzle.global_position
	tween = create_tween()
	tween.tween_property(display_model, "position", Vector3.ZERO, 0.5)
	
