extends KinematicBody2D

onready var game_world = get_parent()
onready var tile = position / ProjectGlobals.TILE_SIZE
onready var health_bar = $HPBar
onready var tween = $MovementTween
onready var ui = get_parent().get_node("CanvasLayer/UI")

export(int) var max_health = 10
export(int) var dam_min = 1
export(int) var dam_max = 4

export(bool) var debug = false

onready var current_health = max_health

func _input(event):
	#return if we're not a pressed event.
	if !event.is_pressed():
		return
	
	if tween.is_active():
		return
		
	if game_world.game_over:
		print("Resetting the world!")
		game_world.reset()
	
	if event.is_action("left"):
		try_move(-1, 0)
	if event.is_action("right"):
		try_move(1, 0)
	if event.is_action("up"):
		try_move(0, -1)
	if event.is_action("down"):
		try_move(0, 1)
		
	game_world.process_turn()

# Function that checks whether we can move into the square we want.
func try_move(dx, dy):
	$Label.text = ""
	var offset = Vector2(dx, dy) * ProjectGlobals.TILE_SIZE
	var target_position = position + offset
	var feature = game_world.get_feature(target_position.x, target_position.y)
	if feature:
		# Clear the feature, then return.
		var ret = game_world.feature_interact(target_position.x, target_position.y)
		if ret != "":
			$Label.text = ret
		return
	
	var enemy = game_world.get_enemy(target_position.x, target_position.y)
	if enemy:
		# deal some damage to it, and return.
		enemy.take_damage(int(rand_range(dam_min, dam_max)))
		#print ("Dealing " + str() + " damage to enemy: " + enemy.name)
		return
			
	if game_world.get_tile(target_position.x, target_position.y) != -1:
		tile = target_position / ProjectGlobals.TILE_SIZE
		tween.interpolate_property(self, "position", position, target_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
func take_damage(damage):
	current_health = max(0, current_health - damage)
	var health_percentage = float(current_health) / float(max_health)
	ui.set_health(health_percentage)
	
	if (current_health == 0):
		print("Game over boyos!")
		game_world.game_over()