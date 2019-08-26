extends Node2D

export(Array) var sprites
var feature_list = {}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type_map = {}
var interacted_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# do a mapping of type to sprite, so we don't pick random things for the various features.
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var data = range(sprites.size())
	for i in random.randi_range(2, 5):
		data.shuffle()
	
	for i in Globals.FEATURE_TYPE.values():
		type_map[i] = sprites[data[i]]
		interacted_map[i] = false
	
	for feature in get_children():
		feature.set_sprite(type_map[feature.type])
		feature_list[feature.tile] = feature

func feature_interact(x, y):
	var feature = get_feature(x, y)
	
	var return_string = ""
	if feature:
		return_string = feature.interact()
		if interacted_map[feature.type]:
			return_string = ""
		else:
			interacted_map[feature.type] = true
		
		if feature.destroy:
			clear_feature(x,y)
	
	return return_string

func get_feature(x, y):
	if Vector2(x,y) in feature_list:
		return feature_list[Vector2(x,y)]
	return null
	
func clear_feature(x, y):
	if Vector2(x,y) in feature_list:
		feature_list[Vector2(x,y)].queue_free()
		feature_list.erase(Vector2(x,y))