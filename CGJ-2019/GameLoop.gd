extends Node2D

const TILE_SIZE = 32

onready var game_map = $GameWorld
onready var features = $Features

var feature_list = {}

func _ready():
	if features:
		for feature in features.get_children():
			feature_list[feature.tile] = feature
	
func tile_coord(x,y):
	return game_map.world_to_map(Vector2(x,y))

func get_tile(x, y):
	var cell_position = game_map.world_to_map(Vector2(x, y))
	return game_map.get_cell(cell_position.x, cell_position.y)
	
func get_feature(x, y):
	var tile_space = tile_coord(x,y)
	if tile_space in feature_list:
		return feature_list[tile_space]
	return null
	
func clear_feature(x, y):
	var tile_space = tile_coord(x, y)
	if tile_space in feature_list:
		feature_list[tile_space].queue_free()
		feature_list.erase(tile_space)
		
func feature_interact(x, y):
	var tile_space = tile_coord(x, y)
	var feature = get_feature(x, y)
	if feature:
		var react = feature.interact()
		if feature.destroy:
			clear_feature(x,y)
		return react
	return "Doesn't look like anything to me"