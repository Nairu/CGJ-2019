extends KinematicBody2D

export(ProjectGlobals.FEATURE_TYPE) var type
export(PackedScene) var pop_label = load("res://Util/pop_label.tscn")
export(String) var default_description = ""

onready var tile = position / ProjectGlobals.TILE_SIZE
var destroy = false
var player = null

func set_sprite(sprite):
	$Sprite.texture = sprite
	
func interact(player):
	return default_description
	
func spawn_pop_label(position, text, duration, distance, color=Color.red):
	var label_instance = pop_label.instance()
	label_instance.position = position
	label_instance.text = text
	label_instance.duration = duration
	label_instance.float_distance = distance
	label_instance.label_color = color
	get_parent().add_child(label_instance)
	label_instance.pop()