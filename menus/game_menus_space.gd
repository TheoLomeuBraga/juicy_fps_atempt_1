extends CanvasLayer
class_name GameMenusSpace

@export var can_pause : bool = true
func pause() -> void:
	get_tree().paused = not get_tree().paused
	$PauseMenu.visible = get_tree().paused
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if can_pause and Input.is_action_just_pressed("pause"):
		pause()
