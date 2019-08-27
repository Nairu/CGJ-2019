extends Control

onready var items_gui = $Panel/ItemList

var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	items_gui.set_max_columns(8)
	items_gui.set_fixed_icon_size(Vector2(64, 64))
	items_gui.set_icon_mode(ItemList.ICON_MODE_TOP)
	items_gui.set_select_mode(ItemList.SELECT_SINGLE)
	items_gui.set_same_column_width(true)
	
#	var dir = Directory.new()
#	dir.open("res://Sprites")
#	dir.list_dir_begin()
#	var idx = 0
#	while true:
#		var file = dir.get_next()
#		if file == "":
#			break
#		elif not file.begins_with(".") and file.ends_with(".png"):
#			var file_path = "res://Sprites/" + file
#			print(file_path)
#			var icon = load(file_path)
#			if icon:
#				items_gui.add_item("", icon, true)
#				items.insert(idx, "test")
#				idx += 1
	
func use_item(idx):
	var item = null
	if idx >= 0 and idx < items.size():
		item = items[idx].duplicate()
		item.tile = items[idx].tile
		item.icon = items[idx].icon
		items.remove(idx)
		items_gui.remove_item(idx)
	return item
	
func add_item(item):
	items.append(item)
	items_gui.add_item(item.name, item.icon, true)
	# Add logic in here to populate the inventory screen from the item class.
	
func get_item(idx):
	if idx >= 0 and idx < items.size():
		return items[idx]
	return null
	
func item_count():
	return items_gui.get_item_count()