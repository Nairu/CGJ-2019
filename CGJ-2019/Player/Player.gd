extends KinematicBody2D

var game_world

# Called when the node enters the scene tree for the first time.
func _ready():
	game_world = get_parent()
	
func _input(event):
	#return if we're not a pressed event.
	if !event.is_pressed():
		return
	
	if event.is_action("left"):
		try_move(-1, 0)
	if event.is_action("right"):
		try_move(1, 0)
	if event.is_action("up"):
		try_move(0, -1)
	if event.is_action("down"):
		try_move(0, 1)

# Function that checks whether we can move into the square we want.
func try_move(dx, dy):
	var target_position = Vector2(position.x + dx*game_world.TILE_SIZE, position.y + dy*game_world.TILE_SIZE)
	var feature = game_world.get_feature(target_position.x, target_position.y)
	if feature:
		# Clear the feature, then return.
		print(game_world.feature_interact(target_position.x, target_position.y))
		return
		
	if game_world.get_tile(position.x + dx, position.y + dy) != -1:
		position += Vector2(dx, dy) * game_world.TILE_SIZE