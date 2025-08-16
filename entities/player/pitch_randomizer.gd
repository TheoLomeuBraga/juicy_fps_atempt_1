extends AudioStreamPlayer
class_name PitchRandomizer

var rng : RandomNumberGenerator

@export var pitch_range : Vector2 = Vector2(0.5,1.5)

func _ready() -> void:
	rng = RandomNumberGenerator.new()

func play_on_random_pitch() -> void:
	pitch_scale = rng.randf_range(pitch_range.x,pitch_range.y)
	play()
