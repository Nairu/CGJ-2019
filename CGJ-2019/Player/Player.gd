extends KinematicBody2D

export(bool) var debug = false
export(int) var max_health = 10
export(int) var dam_min = 1
export(int) var dam_max = 4
export(PackedScene) var pop_label = load("res://Util/pop_label.tscn")

export(ProjectGlobals.CARDINALITY) var direction = ProjectGlobals.CARDINALITY.South

onready var game_world = get_parent()
onready var tile = position / ProjectGlobals.TILE_SIZE
onready var health_bar = $HPBar
onready var tween = $MovementTween
onready var ui = get_parent().get_node("CanvasLayer/UI")
onready var screen_shake = $Sprite/Camera2D/ScreenShake
onready var current_health = max_health

var cur_item = null

func _ready():
	ui.visible = true

func _input(event):
	var triggered_enemies = false
	
	#return if we're not a pressed event.
	if !event.is_pressed():
		return
	
	if ui.inventory_open:
		if event.is_action("space"):
			if cur_item == null:
				# This is where the logic to use items will go, for now just print
				cur_item = ui.get_selected_item()
				if cur_item:
					ui.set_item_icon(cur_item.icon)
					ui.set_inventory_visible(false)
					triggered_enemies = true
			else:
				# We return the item we've got to the inventory after we've got the old one.
				var new_item = ui.get_selected_item()
				ui.add_item(cur_item)
				cur_item = new_item
				if cur_item:
					ui.set_item_icon(cur_item.icon)
					ui.set_inventory_visible(false)
					triggered_enemies = true
		return
	
	if tween.is_active():
		return
		
	if event.is_action("space"):
		if cur_item:
			var ret = cur_item.use_item(self, game_world)
			if ret and ret != "":
				ui.set_description(ret)
			
			if cur_item.consumed:
				ui.set_item_icon(null)
				cur_item = null
				triggered_enemies = true
		
	if game_world.game_over:
		print("Resetting the world!")
		game_world.reset()
	
	if event.is_action("left"):
		triggered_enemies = true
		if direction != ProjectGlobals.CARDINALITY.West:
			direction = ProjectGlobals.CARDINALITY.West
			$Sprite.frame = 6
		else:
			try_move(-1, 0)
	if event.is_action("right"):
		triggered_enemies = true
		if direction != ProjectGlobals.CARDINALITY.East:
			direction = ProjectGlobals.CARDINALITY.East
			$Sprite.frame = 18
		else:
			try_move(1, 0)
	if event.is_action("up"):
		triggered_enemies = true
		if direction != ProjectGlobals.CARDINALITY.North:
			direction = ProjectGlobals.CARDINALITY.North
			$Sprite.frame = 12
		else:
			try_move(0, -1)
	if event.is_action("down"):
		triggered_enemies = true
		if direction != ProjectGlobals.CARDINALITY.South:
			direction = ProjectGlobals.CARDINALITY.South
			$Sprite.frame = 24
		else:
			try_move(0, 1)
		
	if triggered_enemies:
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
			ui.set_description(ret)
#			$Label.text = ret
		return
	
	var enemy = game_world.get_enemy(target_position.x, target_position.y)
	if enemy:
		# deal some damage to it, and return.
		enemy.take_damage(int(rand_range(dam_min, dam_max)))
		#print ("Dealing " + str() + " damage to enemy: " + enemy.name)
		return
			
	if game_world.get_tile(target_position.x, target_position.y) != -1:
		tile = target_position / ProjectGlobals.TILE_SIZE
		# check to see if we get an item from that tile too.
		var item = game_world.get_item(tile.x, tile.y)
		if item:
			ui.add_item(item)
		
		tween.interpolate_property(self, "position", position, target_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
func take_damage(damage):
	var label_instance = pop_label.instance()
	label_instance.position = position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)
	label_instance.text = str(damage)
	label_instance.duration = 0.5
	label_instance.float_distance = 3
	label_instance.final_scale = Vector2(1.2, 1.2)
	get_parent().add_child(label_instance)
	label_instance.pop()
	
	screen_shake.start(0.2, 16, 4)
	
	current_health = max(0, current_health - damage)
	var health_percentage = float(current_health) / float(max_health)
	ui.set_health(health_percentage)
	
	if (current_health == 0):
		print("Game over boyos!")
		game_world.game_over()