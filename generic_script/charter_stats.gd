extends Node
class_name CharterStats

@export var faction : DamageInfo.Factions
@export var max_health : int = 100
@export var health : int = 100
var display_material : ShaderMaterial = preload("res://shaders_materials/stat_aura_display.tres").duplicate()

var display_color : Color
var display_fresnel : float

signal damage_recived(damage : int)

func set_overlay_material_on(node : Node) -> void:
	
	if node is GeometryInstance3D:
		node.material_overlay = display_material
		
	
	for n in node.get_children():
		set_overlay_material_on(n)

func _ready() -> void:
	display_color = Color(0.0,0.0,0.0,0.0)
	set_overlay_material_on(get_parent())
	


var tween : Tween
func deal_damage(damage_info : DamageInfo) -> void:
	if damage_info.faction != faction or damage_info.faction == DamageInfo.Factions.NONE:
		
		health -= damage_info.damage
		health = max(0,health)
		
		damage_recived.emit(damage_info.damage)
		
		if tween != null:
			tween.kill()
		
		tween = create_tween()
		display_color = Color.WHITE
		display_color.a = 1.0
		
		tween.tween_property(self, "display_color:a", 0, 0.2).set_trans(Tween.TRANS_LINEAR)

const damage_fx : PackedScene = preload("res://generic_script/damage_fx.tscn")

static func deal_damage_to(node : Node,damage_info : DamageInfo) -> bool:
	var damage_target : CharterStats
	if node is CharterStats:
		damage_target = node
	else:
		for n in node.get_children():
			if n is CharterStats:
				damage_target = n
	
	if damage_target != null:
		damage_target.deal_damage(damage_info)
		
		var damage_position : Node3D = node
		if damage_position != null:
			var d : Node3D = damage_fx.instantiate()
			node.add_child(d)
			d.global_position = damage_position.global_position
		
		return true
	return false

func _process(delta: float) -> void:
	display_material.set_shader_parameter("color", display_color)
