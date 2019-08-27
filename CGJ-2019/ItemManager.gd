extends Node2D

var item_list = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_children():
		item_list[item.tile] = item

func item_exists(x, y):
	return (Vector2(x,y) in item_list)

func get_item(x, y):
	if Vector2(x,y) in item_list:
		var item = item_list[Vector2(x,y)].duplicate()
		item.tile = item_list[Vector2(x,y)].tile
		item.icon = item_list[Vector2(x,y)].icon
		return item
	return null
	
func clear_item(x, y):
	if Vector2(x,y) in item_list:
		item_list[Vector2(x,y)].queue_free()
		item_list.erase(Vector2(x,y))