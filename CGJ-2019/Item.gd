extends Node2D

onready var tile = position / ProjectGlobals.TILE_SIZE
onready var icon = $Sprite.texture
export(ProjectGlobals.ITEM_TYPE) var type

var consumed = false

export(bool) var consumable = true
export(int) var usages = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE

func set_sprite(sprite):
	$Sprite.texture = sprite
	$Sprite.position += Vector2(rand_range(-3, 4), rand_range(-3, 4))
	icon = sprite

func use_item(player, game_world):
	# we can get the players direction, check if it is using this on a 
	# door and unlock it.
	var ret_text = "Player is using item: " + name
	var tile_coord = game_world.adjacent_tile_world_coord(player.position.x, player.position.y, player.direction)
	var feature = game_world.get_feature(tile_coord.x, tile_coord.y)
	if feature:
		if feature.type == ProjectGlobals.FEATURE_TYPE.Door:
			ret_text = feature.unlock(self)
			if feature.locked == true || feature.stuck == true:
				return ret_text
	
	if consumable:
		usages -= 1
		
		if usages == 0:
			consumed = true
	return ret_text