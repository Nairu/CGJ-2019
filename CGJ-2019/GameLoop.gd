extends Node2D

onready var game_map = $GameWorld
onready var features = $Features
onready var items = $Items
onready var enemies = $Enemies
onready var player = $Player
onready var game_over_screen = $CanvasLayer/GameOver

var game_over = false

func process_turn():
	game_map.enable_points()
	enemies.handle_turns(self, player)

func tile_coord(x,y):
	return game_map.world_to_map(Vector2(x,y))

func get_tile(x, y):
	var cell_position = game_map.world_to_map(Vector2(x, y))
	return game_map.get_cell(cell_position.x, cell_position.y)
	
func set_tile_visible(x, y, visible):
	game_map.set_cell(x, y, 0 if visible else -1)
	game_map.update_bitmask_area(Vector2(x, y))
	
func get_feature(x,y):
	var tile_space = tile_coord(x, y)
	return features.get_feature(tile_space.x, tile_space.y)
	
func get_enemy(x,y):
	var tile_space = tile_coord(x, y)
	return enemies.get_enemy(tile_space.x, tile_space.y)
	
func clear_feature(x, y):
	var tile_space = tile_coord(x, y)
	features.clear_feature(tile_space.x, tile_space.y)
	
func get_item(x, y):
	var tile_space = tile_coord(x, y)
	var item = items.get_item(x, y)
	if item:
		items.clear_item(x, y)
	return item
		
func feature_interact(x, y):
	var tile_space = tile_coord(x, y)
	return features.feature_interact(tile_space.x, tile_space.y)
	
func path(start, end):
	return game_map.get_astar_path(start, end)
	
func path_to_player(start):
	return game_map.get_astar_path(start, player.position)
	
func set_point_disabled(x, y, disabled):
	game_map.set_point_disabled(tile_coord(x, y), disabled)

func traversable(x, y):
	var traversable = true
	var tile_space = tile_coord(x, y)
	if features.feature_exists(tile_space.x, tile_space.y):
		traversable = false
	if tile_space == player.tile:
		traversable = false
	if enemies.get_enemy(tile_space.x, tile_space.y):
		traversable = false
	return traversable
	
func game_over():
	game_over_screen.visible = true
	game_over = true
	
func reset():
	game_over = false
	get_tree().reload_current_scene()