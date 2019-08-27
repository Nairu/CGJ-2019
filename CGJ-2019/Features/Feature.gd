extends KinematicBody2D

var tile = Vector2(0,0)
var destroy = false
export(ProjectGlobals.FEATURE_TYPE) var type

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE
	
func set_sprite(sprite):
	$Sprite.texture = sprite
	
func interact():
	return "Doesn't look like anything to me"