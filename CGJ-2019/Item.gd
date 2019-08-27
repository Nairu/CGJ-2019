extends Node2D

onready var tile = position / ProjectGlobals.TILE_SIZE
onready var icon = $Sprite.texture

var consumed = false

export(bool) var consumable = true
export(int) var usages = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE

func use_item(player, game_world):
	print ("Player is using item: " + name)
	
	if consumable:
		usages -= 1
		
		if usages == 0:
			consumed = true