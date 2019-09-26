extends "res://Features/Feature.gd"

export(Array) var toggled_items
export(bool) var down = false

export(Texture) var lever_up
export(Texture) var lever_down

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = lever_down if down else lever_up
	
func _process(delta):
	$Sprite.texture = lever_down if down else lever_up
	
func interact(player):
	if destroy:
		return
	
	down = !down
	for item in toggled_items:
		get_node(item).visible = !get_node(item).visible
		
	$Sprite.texture = lever_down if down else lever_up
	return ""