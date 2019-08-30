extends "res://Features/Feature.gd"

export(PackedScene) var next_level
export(bool) var flip

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.flip_h = flip

func interact(player):
	# Go to the next level!
	# Load the players inventory into globals.
	ProjectGlobals.setInventory(player.ui.get_items())
	ProjectGlobals.music_seconds = $"/root/GameScene/Song".get_playback_position()
	get_tree().change_scene_to(next_level)