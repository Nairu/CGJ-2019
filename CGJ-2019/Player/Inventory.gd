extends Control

class_name InventorySystem

onready var items : ItemList = $Inventory/Items/ItemList
onready var weapons : ItemList = $Inventory/Weapons/WeaponList
onready var info : RichTextLabel = $Inventory/Details/DetailText

func reset_selection() -> void:
	items.unselect_all()
	weapons.unselect_all()
	info.clear()
	

func _ready():
	_setup_item_lists(items)
	_setup_item_lists(weapons)	
	
	for i in 15:
		#inv.add_item("Test", load("res://Sprites/coin-pile.png"))
		items.add_icon_item(load("res://Sprites/food.png"))
	for i in 10:
		weapons.add_icon_item(load("res://Sprites/fire-stave.png"))


func _setup_item_lists(list : ItemList) -> void:	
	list.set_max_columns(5)
	list.set_fixed_icon_size(Vector2(32, 32))
	list.set_icon_mode(ItemList.ICON_MODE_TOP)
	list.set_select_mode(ItemList.SELECT_SINGLE)
	list.set_same_column_width(true)