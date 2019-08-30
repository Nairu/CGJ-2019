extends Node2D

var enemy_list = []

func _ready():
    var random = RandomNumberGenerator.new()
    random.randomize()

    for enemy in get_children():
        enemy_list.append(enemy)

func handle_turns(game_manager, player):
	# This gets us the min and max position of the camera, so we can check to see if enemies are in view.
	var ctrans = get_canvas_transform()
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	var max_pos = min_pos + view_size
	
	var dead_enemies = []
	for enemy in enemy_list:
		if enemy.dead:
			continue
		
		var previous_pos = enemy.position
		if enemy.position > min_pos and enemy.position < max_pos:
			if not enemy.ignores_path:
				var path = get_traversable_path(enemy, game_manager, player)
				if path:
					enemy.path = path
				else:
					enemy.path = [enemy.position]
			
			enemy.take_turn(game_manager, player)
			if enemy.tile == player.tile:
				enemy.position = previous_pos
		
	for enemy in enemy_list:
		if enemy.dead:
			dead_enemies.append(enemy)
	
	for enemy in dead_enemies:
		remove_enemy(enemy)

func get_traversable_path(enemy, game_manager, player):
	var path = game_manager.path_to_player(enemy.position)
#	if path and path.size() > 1 and !game_manager.traversable(path[1].x, path[1].y):
#		# check his north, south, east and west to see if there's anyone there.
#		var temp_path = game_manager.path(enemy.position, player.position + Vector2(0, -1))
#		if temp_path and temp_path.size() > 1 and game_manager.traversable(temp_path[1].x, temp_path[1].y):
#			path = temp_path
#		temp_path = game_manager.path(enemy.position, player.position + Vector2(0, 1))
#		if temp_path and temp_path.size() > 1 and game_manager.traversable(temp_path[1].x, temp_path[1].y) and temp_path.size() < path.size():
#			path = temp_path
#		temp_path = game_manager.path(enemy.position, player.position + Vector2(-1, 0))
#		if temp_path and temp_path.size() > 1 and game_manager.traversable(temp_path[1].x, temp_path[1].y) and temp_path.size() < path.size():
#			path = temp_path
#		temp_path = game_manager.path(enemy.position, player.position + Vector2(1, 0))
#		if temp_path and temp_path.size() > 1 and game_manager.traversable(temp_path[1].x, temp_path[1].y) and temp_path.size() < path.size():
#			path = temp_path
	
	return path

func get_enemy(x, y):
    var ret_enemy = null
    for enemy in enemy_list:
        if enemy.tile == Vector2(x,y):
            ret_enemy = enemy
    return ret_enemy
	
func remove_enemy(enemy):
	enemy_list.erase(enemy)
	enemy.queue_free()
	
func add_enemy(enemy):
	enemy_list.append(enemy)
	add_child(enemy)