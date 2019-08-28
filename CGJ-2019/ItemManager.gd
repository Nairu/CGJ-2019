extends Node2D

var item_list = {}
onready var game_world = get_node("/root/GameScene/GameWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in game_world.traversable_tiles:
		item_list[Vector2(tile.x, tile.y)] = []
	for item in get_children():
		item_list[item.tile].append(item)

func add_item(item):
	if not item.tile in item_list:
		item_list[item.tile] = []
	item_list[item.tile].append(item)
	add_child(item)

func items_exists(x, y):
	var exists = false
	
	if Vector2(x,y) in item_list:
		if item_list[Vector2(x,y)].size() > 0:
			exists = true
	
	return exists

func get_items(x, y):
	var items = []
	if items_exists(x,y):
		print ("Item at " + str(Vector2(x,y)))
		for item in item_list[Vector2(x,y)]:
			var cur_item = item.duplicate()
			cur_item.tile = item.tile
			cur_item.icon = item.icon
			items.append(cur_item)
	return items
	
func clear_items(x, y):
	var removed_items = []
	if items_exists(x,y):
		for i in item_list[Vector2(x,y)]:
			i.queue_free()
		item_list[Vector2(x,y)].clear()