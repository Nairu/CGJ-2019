extends KinematicBody2D

var tile = Vector2(0,0)
var destroy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = Vector2(position.x/32, position.y/32)
	
func set_sprite(sprite):
	$Sprite.texture = sprite
	
func interact():
	return "Doesn't look like anything to me"