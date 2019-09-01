extends "res://Items/Item.gd"

export(int) var dam_min = 3
export(int) var dam_max = 5
var enemy = null
var attack_width = 3

func set_sprite(sprite):
	.set_sprite(sprite)
	
func use_item(player, game_world):
	#enemy.take_damage(int(rand_range(dam_min, dam_max)))
	var position = get_tiles(player, game_world)
	for pos in position:
		enemy = game_world.get_enemy(pos.x, pos.y)
		if enemy:
			enemy.take_damage(int(rand_range(dam_min, dam_max)))
	
	return ""
	
func get_tiles(player, game_world):
	var offset_tile = game_world.adjacent_tile_world_coord(player.position.x, player.position.y, player.direction)
	match player.direction:
		ProjectGlobals.CARDINALITY.West:
			var north = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.North)
			var south = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.South)
			return [offset_tile, north, south]
		ProjectGlobals.CARDINALITY.East:
			var north = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.North)
			var south = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.South)
			return [offset_tile, north, south]
		ProjectGlobals.CARDINALITY.North:
			var east = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.East)
			var west = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.West)
			return [offset_tile, east, west]
		ProjectGlobals.CARDINALITY.South:
			var east = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.East)
			var west = game_world.adjacent_tile_world_coord(offset_tile.x, offset_tile.y, ProjectGlobals.CARDINALITY.West)
			return [offset_tile, east, west]