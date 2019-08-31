extends Node2D

export(Array) var sprites
var feature_list = {}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type_map = {}
var description_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_type_descriptions()
	
	# do a mapping of type to sprite, so we don't pick random things for the various features.
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var sprite_list = sprites.duplicate()
	
	for i in random.randi_range(2, 5):
		sprite_list.shuffle()
	
	for i in ProjectGlobals.FEATURE_TYPE.values():
		print("Current index: " + str(i))
		if i == ProjectGlobals.FEATURE_TYPE.Lever:
			type_map[i] = load("res://Sprites/lever-up-front.png")
		else:
			var sprite = sprites.pop_front()
			print(sprite)
			type_map[i] = sprite_list.pop_back()
	
	for feature in get_children():
		feature.set_sprite(type_map[feature.type])
		feature_list[feature.tile] = feature

func set_type_descriptions():
	description_map[ProjectGlobals.FEATURE_TYPE.Door] = "This wooden portal set into the wall appears to have a handle..."
	description_map[ProjectGlobals.FEATURE_TYPE.Wardrobe] = "This large wooden structure seems to hold clothes..."
	description_map[ProjectGlobals.FEATURE_TYPE.Chest] = "This squat wooden box contains interesting items..."
	description_map[ProjectGlobals.FEATURE_TYPE.ChestDrawer] = "This wooden structure contains many hats..."
	description_map[ProjectGlobals.FEATURE_TYPE.Bookcase] = "This tall wooden object seems to be stacked with books..."
	description_map[ProjectGlobals.FEATURE_TYPE.Stairs] = "The floor goes upwards here, taking me to another floor..."

func feature_interact(player, x, y):
	var feature = get_feature(x, y)
	
	var return_string = ""
	if feature:
		if feature.type in description_map:
			return_string = description_map[feature.type]
			description_map.erase(feature.type)
		else:
			return_string = feature.interact(player)
			
	return return_string

func _process(delta):
	for feature in feature_list:
		if feature_list[feature].destroy:
			if feature_list[feature].get_node("Noise") and feature_list[feature].get_node("Noise").is_playing() == false:
				clear_feature(feature.x, feature.y)

func feature_exists(x, y):
	return (Vector2(x,y) in feature_list) and feature_list[Vector2(x,y)].visible

func get_feature(x, y):
	if Vector2(x,y) in feature_list:
		var feature = feature_list[Vector2(x,y)]
		if feature.visible:
			return feature
	return null
	
func clear_feature(x, y):
	if Vector2(x,y) in feature_list:
		feature_list[Vector2(x,y)].queue_free()
		feature_list.erase(Vector2(x,y))