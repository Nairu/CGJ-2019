extends Node2D

onready var game_map = $GameWorld
onready var features = $Features
onready var items = $Items
onready var enemies = $Enemies
onready var player = $Player
onready var game_over_screen = $CanvasLayer/GameOver

var game_over = false
#
#func _ready():
#	$Song.play(ProjectGlobals.music_seconds)

func process_turn():
	game_map.enable_points()
	enemies.handle_turns(self, player)

func tile_coord(x,y):
	return game_map.world_to_map(Vector2(x,y))
	
func adjacent_tile_world_coord(x, y, direction):
	match direction:
		ProjectGlobals.CARDINALITY.North:
			return Vector2(x,y-32)
		ProjectGlobals.CARDINALITY.East:
			return Vector2(x+32,y)
		ProjectGlobals.CARDINALITY.South:
			return Vector2(x,y+32)
		ProjectGlobals.CARDINALITY.West:
			return Vector2(x-32,y)
	return Vector2(x,y)
	
func adjacent_tile_coord(x, y, direction):
	match direction:
		ProjectGlobals.CARDINALITY.North:
			return tile_coord(x,y-32)
		ProjectGlobals.CARDINALITY.East:
			return tile_coord(x+32,y)
		ProjectGlobals.CARDINALITY.South:
			return tile_coord(x,y+32)
		ProjectGlobals.CARDINALITY.West:
			return tile_coord(x-32,y)
	return tile_coord(x,y)

func get_tile(x, y):
	var cell_position = game_map.world_to_map(Vector2(x, y))
	return game_map.get_cell(cell_position.x, cell_position.y)
	
func set_tile_visible(x, y, visible):
	game_map.set_cell(x, y, 0 if visible else -1)
	game_map.update_bitmask_area(Vector2(x, y))
	
func get_feature(x,y):
	var tile_space = tile_coord(x, y)
	return features.get_feature(tile_space.x, tile_space.y)
	
func add_enemy(enemy):
	enemies.add_enemy(enemy)
	
func get_enemy(x,y):
	var tile_space = tile_coord(x, y)
	return enemies.get_enemy(tile_space.x, tile_space.y)
	
func clear_feature(x, y):
	var tile_space = tile_coord(x, y)
	features.clear_feature(tile_space.x, tile_space.y)
	
func get_item(x, y):
	var tile_space = tile_coord(x, y)
	var item_list = items.get_items(x, y)
	if item_list and item_list.size() > 0:
		items.clear_items(x, y)
	return item_list
	
func feature_interact(x, y):
	var tile_space = tile_coord(x, y)
	return features.feature_interact(player, tile_space.x, tile_space.y)
	
func path(start, end):
	return game_map.get_astar_path(start, end)
	
func path_to_player(start):
	return game_map.get_astar_path(start, player.position)
	
func set_point_disabled(x, y, disabled):
	game_map.set_point_disabled(tile_coord(x, y), disabled)

func path_blocked_by_feature(path):
	for point in path:
		var tile_space = tile_coord(point.x, point.y)
		if features.feature_exists(tile_space.x, tile_space.y):
			return true
	return false

func traversable(x, y, ignore_enemies=false):
	var traversable = true
	var tile_space = tile_coord(x, y)
	if features.feature_exists(tile_space.x, tile_space.y):
		print("Can't move because of feature")
		traversable = false
	if tile_space == player.tile:
		print("Can't move because of player")
		traversable = false
	if ignore_enemies == false and enemies.get_enemy(tile_space.x, tile_space.y):
		print("Can't move because of enemy")
		traversable = false
	if get_tile(x, y) == -1:
		print("Can't move because of wall")
		traversable = false
	return traversable
	
func game_over():
	game_over_screen.visible = true
	game_over = true
	
func reset():
	game_over = false
	ProjectGlobals.music_seconds = $Song.get_playback_position()
	get_tree().reload_current_scene()