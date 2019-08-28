extends "res://Features/Feature.gd"

export(PackedScene) var next_level
export(bool) var flip

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.flip_h = flip

func interact():
	# Go to the next level!
	get_tree().change_scene_to(next_level)