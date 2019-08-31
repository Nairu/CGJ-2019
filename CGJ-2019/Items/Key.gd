extends "res://Items/Item.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE

func set_sprite(sprite):
	.set_sprite(sprite)

func use_item(player, game_world):
	var ret_text = "The key can't be used here."
	var tile_coord = game_world.adjacent_tile_world_coord(player.position.x, player.position.y, player.direction)
	var feature = game_world.get_feature(tile_coord.x, tile_coord.y)
	if feature:
		if feature.type == ProjectGlobals.FEATURE_TYPE.Door:
			if feature.locked == false:
				return ""
			
			ret_text = feature.unlock(self)
			if feature.locked == true || feature.stuck == true:
				return ret_text
			else:
				consumed = true
	
	#.use_item(player, game_world)
	# we can get the players direction, check if it is using this on a 
	# door and unlock it.
	return ret_text