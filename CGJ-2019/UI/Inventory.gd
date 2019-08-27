extends Control

onready var items_gui = $Panel/ItemList

var items = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	items_gui.set_max_columns(8)
	items_gui.set_fixed_icon_size(Vector2(64, 64))
	items_gui.set_icon_mode(ItemList.ICON_MODE_TOP)
	items_gui.set_select_mode(ItemList.SELECT_SINGLE)
	items_gui.set_same_column_width(true)
	
	var dir = Directory.new()
	dir.open("res://Sprites")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".png"):
			var file_path = "res://Sprites/" + file
			print(file_path)
			var icon = load(file_path)
			items_gui.add_item("", icon, true)