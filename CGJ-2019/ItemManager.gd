extends Node2D

var item_list = {}
onready var game_world = get_node("/root/GameScene/GameWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
#	print (game_world)
#	print (game_world.game_map)
	for tile in game_world.traversable_tiles:
		item_list[Vector2(tile.x, tile.y)] = []
	for item in get_children():
		item_list[item.tile].append(item)

func add_item(item):
	if not item.tile in item_list:
		item_list[item.tile] = []
	item_list[item.tile].append(item)
	add_child(item)

func item_exists(x, y):
	var exists = false
	
	if Vector2(x,y) in item_list:
		if item_list[Vector2(x,y)].size() > 0:
			exists = true
	
	return exists

func get_item(x, y):
	if item_exists(x,y):
		var item = item_list[Vector2(x,y)][0].duplicate()
		item.tile = item_list[Vector2(x,y)].tile
		item.icon = item_list[Vector2(x,y)].icon
		return item
	return null
	
func clear_item(x, y):
	if item_exists(x,y):
		item_list[Vector2(x,y)][0].queue_free()