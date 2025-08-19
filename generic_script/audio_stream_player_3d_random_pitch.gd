extends AudioStreamPlayer3D
class_name AudioStreamPlayer3dRandomPitch


func _ready() -> void:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	pitch_scale = rng.randf_range(2.0,3.0)
