extends KinematicBody2D

onready var tile = position / ProjectGlobals.TILE_SIZE
var destroy = false
export(ProjectGlobals.FEATURE_TYPE) var type

func set_sprite(sprite):
	$Sprite.texture = sprite
	
func interact():
	return "Doesn't look like anything to me"