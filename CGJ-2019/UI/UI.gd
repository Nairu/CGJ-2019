extends Control

var inventory_open = false
var current_idx = 0

onready var health_bar = $HUD/Panel/Container/Health/FullHealth
onready var full_width = $HUD/Panel/Container/Health/DamagedHealth.rect_size.x
onready var description_popup = $HUD/Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_health(health_percentage):
	health_bar.rect_size.x = full_width * health_percentage
	
func set_description(description):
	var label = description_popup.get_node("Panel/Panel3/DescriptionLabel") as Label
	label.text = str(description)
	description_popup.popup()
	
func add_item(item):
	$Inventory.add_item(item)
	
func get_items():
	return $Inventory.get_items()
	
func set_items(items):
	$Inventory.set_items(items)
	
func get_selected_item():
	var item = $Inventory.use_item(current_idx)
	return item
	
func set_item_icon(icon):
	$HUD/Panel/Container/Item2/ItemSprite.texture = icon

func set_inventory_visible(visible):
	$Inventory.visible = visible
	inventory_open = visible
	$Inventory/Panel/ItemList.select(0)
	
func _input(event):
	if !event.is_pressed():
		return
		
	if event.is_action("esc"):
		# toggle the inventory.
		$Inventory.visible = !$Inventory.visible
		inventory_open = $Inventory.visible
		return
	
	if event.is_action("space"):
		if description_popup.visible:
			description_popup.visible = false
			return

	if inventory_open:
		if event.is_action("left"):
			current_idx -= 1
		if event.is_action("right"):
			current_idx += 1
		if event.is_action("up"):
			current_idx -= $Inventory/Panel/ItemList.max_columns-1
		if event.is_action("down"):
			current_idx += $Inventory/Panel/ItemList.max_columns-1
		
		current_idx = max(0, min($Inventory.item_count()-1, current_idx))
		$Inventory/Panel/ItemList.select(current_idx)
	