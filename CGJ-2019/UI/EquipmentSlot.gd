extends Control
class_name EquipmentSlot


var _item : Item


func get_item() -> Item:
	return _item


func set_equipment_slot(item : Item, text : String) -> void:
	_item = item

	get_node("UseLabel").text = text
	get_node("Sprite").texture = load(_item.sprite)


func clear_slot() -> void:
	_item = Item.new()
	get_node("UseLabel").text = ""
	get_node("Sprite").texture = null