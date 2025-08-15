@tool
extends Node3D

var animatin_tree : AnimationTree

enum TransitionEstates {IDLE,GRAB_WEPON,LOWER_WEPON,JUMP,FALL,SHOT_AUTO,SHOT_STRONG,SHOT_PUNP,SHOT_SEMI_AUTOMATIC}

var string_to_estate : Dictionary[String,TransitionEstates] = {
	"" : TransitionEstates.IDLE,
	"idle" : TransitionEstates.IDLE,
	"grab_wepon" : TransitionEstates.GRAB_WEPON,
	"lower_wepon" : TransitionEstates.LOWER_WEPON,
	"jump" : TransitionEstates.JUMP,
	"fall" : TransitionEstates.FALL,
	"shot_auto" : TransitionEstates.SHOT_AUTO,
	"shot_strong" : TransitionEstates.SHOT_STRONG,
	"shot_punp" : TransitionEstates.SHOT_PUNP,
	"shot_semi_automatic" : TransitionEstates.SHOT_SEMI_AUTOMATIC,
}

var estate_to_string : Dictionary[TransitionEstates,String]

var text_label : RichTextLabel

@export var muzle : Node3D

func _ready() -> void:
	animatin_tree = $AnimationTree
	
	text_label = $SubViewport/RichTextLabel
	
	for key : String in string_to_estate:
		var value : TransitionEstates = string_to_estate[key]
		estate_to_string[value] = key
	
	if muzle != null:
		$charter_armature/Skeleton3D/Cube_003/muzle.remote_path = muzle.get_path()

@export_multiline var display_text = "": 
	get():
		if text_label != null:
			return text_label.text
		return display_text
	set(value):
		display_text = value
		if text_label != null:
			text_label.text = value

@export_range(0.0,1.0) var walk_influence : float = 1.0 : 
	get():
		if animatin_tree != null:
			return animatin_tree.get("parameters/walk_influence/add_amount")
		return 0
	set(value):
		if animatin_tree != null:
			animatin_tree.set("parameters/walk_influence/add_amount",value)


@export_range(0.0,5.0) var walk_speed : float = 0.0 :
	get():
		if animatin_tree != null:
			return animatin_tree.get("parameters/walk_speed/scale")
		return 0
	set(value):
		if animatin_tree != null:
			animatin_tree.set("parameters/walk_speed/scale",value)


@export_range(0.0,1.0) var walk_sway_influence : float = 1.0 : 
	get():
		if animatin_tree != null:
			return animatin_tree.get("parameters/walk_sway_influence/add_amount")
		return 0
	set(value):
		if animatin_tree != null:
			animatin_tree.set("parameters/walk_sway_influence/add_amount",value)

@export_range(-1.0,1.0) var walk_sway_direction : float = 0.0 : 
	get():
		if animatin_tree != null:
			return animatin_tree.get("parameters/walk_sway_direction/blend_position")
		return 0
	set(value):
		if animatin_tree != null:
			animatin_tree.set("parameters/walk_sway_direction/blend_position",value)



@export var transition_estate : TransitionEstates = TransitionEstates.IDLE : 
	get():
		return transition_estate
	set(value):
		transition_estate = value
		animatin_tree.set("parameters/transition_estate/transition_request",estate_to_string[value])
