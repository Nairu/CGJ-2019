extends Control

class_name InventorySystem

onready var items : ItemList = $Inventory/Items/ItemList
onready var weapons : ItemList = $Inventory/Weapons/WeaponList
onready var info_name : RichTextLabel = $Inventory/Details/NameText
onready var info_detail : RichTextLabel = $Inventory/Details/DetailText


func _on_ItemList_item_selected(index: int) -> void:
	_toggle_details(false)
	var item : Item = (items.get_item_metadata(index))
	info_name.text = item.get_title()
	info_detail.text = item.get_description()


func _on_itemlist_focus_exited() -> void:
	reset_selection()


func _ready():
	_setup_item_lists(items)
	_setup_item_lists(weapons)
		
	var item := Item.new()
	item.sprite = "res://Sprites/food.png"
	item.title =  "Food"
	item.description = "Delicious food to consume!"
	
	items.add_icon_item(load(item.sprite))
	items.set_item_metadata(0, item)


	item = Item.new()
	item.sprite = "res://Sprites/HealthPotion.png"
	item.title =  "Red Liquid"
	item.description = "Smells...healthy?"
	
	items.add_icon_item(load(item.sprite))
	items.set_item_metadata(1, item)


	item = Item.new()
	item.sprite = "res://Sprites/fire-stave.png"
	item.title =  "Magical Staff"
	item.description = "An enchanted wooden stick, with fire!"
	
	weapons.add_icon_item(load(item.sprite))
	weapons.set_item_metadata(0, item)


func _setup_item_lists(list : ItemList) -> void:	
	list.set_max_columns(5)
	list.set_fixed_icon_size(Vector2(32, 32))
	list.set_icon_mode(ItemList.ICON_MODE_TOP)
	list.set_select_mode(ItemList.SELECT_SINGLE)
	list.set_same_column_width(true)


func _toggle_details(toggle : bool) -> void:
	get_node("Inventory/Details").visible = !toggle


func reset_selection() -> void:
	items.unselect_all()
	weapons.unselect_all()
	info_name.text = ""
	info_detail.clear()
	_toggle_details(true)

