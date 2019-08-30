extends Node2D
class_name Item

onready var tile = position / ProjectGlobals.TILE_SIZE
onready var icon = $Sprite.texture
export(ProjectGlobals.ITEM_TYPE) var type

var consumed = false

export(bool) var consumable = true
export(int) var usages = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE
	icon = $Sprite.texture

func set_sprite(sprite):
	$Sprite.texture = sprite
	icon = sprite

func use_item(player, game_world):
	if consumable:
		usages -= 1
		
		if usages == 0:
			consumed = true
	# we can get the players direction, check if it is using this on a 
	# door and unlock it.
	return "Player used item " + name