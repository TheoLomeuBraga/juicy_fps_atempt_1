extends CanvasLayer
class_name PauseMenu

@onready var control_base : Control = $Control

var tween_x : Tween
var tween_y : Tween

func set_pivo() -> void:
	control_base.pivot_offset = control_base.size / 2
	

func jely_effect() -> void:
	
	control_base.scale = Vector2(0.0,0.0)
	
	tween_x = create_tween()
	tween_x.tween_property(control_base, "scale:x", 1.0, 0.4).set_trans(Tween.TRANS_ELASTIC)
	
	tween_y = create_tween()
	tween_y.tween_property(control_base, "scale:y", 1.0, 0.5).set_trans(Tween.TRANS_ELASTIC)

func _ready() -> void:
	call_deferred("set_pivo")
	call_deferred("jely_effect")
	$Control/CenterContainer/Panel/VBoxContainer/HBoxContainer/window_exit_button.pressed.connect(GameMenus.pause)
	


	

func _on_visibility_changed() -> void:
	if not visible:
		tween_x = null
	else:
		jely_effect()
	
	
