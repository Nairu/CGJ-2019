extends Node2D

const TILE_SIZE = 32

onready var game_map = $GameWorld
onready var features = $Features
onready var enemies = $Enemies
onready var player = $Player

func process_turn():
	for enemy in enemies.get_children():
		var previous_pos = enemy.position
		enemy.path = $GameWorld.get_astar_path(enemy.position, player.position)
		enemy.take_turn()
		if enemy.position == player.position:
			enemy.position = previous_pos
	
func tile_coord(x,y):
	return game_map.world_to_map(Vector2(x,y))

func get_tile(x, y):
	var cell_position = game_map.world_to_map(Vector2(x, y))
	return game_map.get_cell(cell_position.x, cell_position.y)
	
func get_feature(x,y):
	var tile_space = tile_coord(x, y)
	return features.get_feature(tile_space.x, tile_space.y)
	
func clear_feature(x, y):
	var tile_space = tile_coord(x, y)
	features.clear_feature(tile_space.x, tile_space.y)
		
func feature_interact(x, y):
	var tile_space = tile_coord(x, y)
	return features.feature_interact(tile_space.x, tile_space.y)