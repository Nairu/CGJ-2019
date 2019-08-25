extends Node2D

# Constant Values -------------------------------------------------
const TILE_SIZE = 32
const PLAYER_VISIBILITY = 10
const PLAYER_IMMEDIATE_VISIBILITY = 3
enum Tile {Door, Floor, Wall, Stone, Hatch, Ladder}
var map_image = preload("res://Maps/MapTest1.png")
const EnemyScene = preload("res://Default Enemy/Enemy.tscn")

class Enemy extends Reference:
	var sprite_node
	var tile
	var full_hp
	var hp
	var dead = false
	
	func _init(game, enemy_level, x, y):
		full_hp = 1 + enemy_level * 2
		hp = full_hp
		tile = Vector2(x, y)
		sprite_node = EnemyScene.instance()
		sprite_node.frame = enemy_level
		sprite_node.position = tile * TILE_SIZE
		game.add_child(sprite_node)
		
	func remove():
		sprite_node.queue_free()
		
	func take_damage(game, dmg):
		if dead:
			return
		
		hp = max(0, hp - dmg)
		sprite_node.get_node("HPBar").rect_size.x = TILE_SIZE * hp / full_hp
		
		if hp == 0:
			dead = true
			
	var turn_speed = 1
	var turn_counter = 0
	var encountered_player = false
	func act(game):
		if !encountered_player:
			return
		
		if turn_counter != turn_speed:
			turn_counter += 1
			return
		
		turn_counter = 0
		
		var my_point = game.enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y, 0))
		var player_point = game.enemy_pathfinding.get_closest_point(Vector3(game.player_tile.x, game.player_tile.y, 0))
		if my_point == player_point:
			return
		
		var path = game.enemy_pathfinding.get_point_path(my_point, player_point)
		if path:
			assert(path.size() > 1)
			var move_tile = Vector2(path[1].x, path[1].y)
			
			if move_tile == game.player_tile:
				# Do some damage
				print ("Damage on the player!")
			else:
				var blocked = false
				for enemy in game.enemies:
					if enemy.tile == move_tile:
						blocked = true
						break
#				if game.map[move_tile.x][move_tile.y] != Tile.Floor:
#					blocked = true
				
				if !blocked:
					tile = move_tile

# Current Level ---------------------------------------------------
var level_num = 0
var map = []
var level_size = Vector2(0,0)
var enemies = []

# Node References -------------------------------------------------
onready var tile_map = $TileMap
onready var visibility_map = $VisibilityMap
onready var player = $Player

# Game State ------------------------------------------------------
var player_tile = Vector2(0,0)
var enemy_pathfinding

# Functions -------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(1280, 720))
	build_level()
	call_deferred("update_visuals")
	
func build_level():
	map.clear()
	tile_map.clear()
	for enemy in enemies:
		enemy.remove()
	enemies.clear()
	
	enemy_pathfinding = AStar.new()
	
	var level_size_x = 30
	var level_size_y = 30
	# Load the image as pixel data.
	map_image = Image.new()
	map_image.load("res://Maps/MapTest1.png")
	level_size_x = map_image.get_width()
	level_size_y = map_image.get_height()
	map_image.lock()
	
	if (map_image):
		for x in range(level_size_x):
			map.append([])
			for y in range(level_size_y):
				# Get the pixel and do different things based on its color.
				var color = map_image.get_pixel(x, y)
				if color == Color(1, 1, 1):
					player_tile = Vector2(x, y)
					map[x].append(Tile.Floor)
					tile_map.set_cell(x, y, Tile.Floor)
					clear_path(Vector2(x, y))
				elif color == Color(1, 0, 0):
					map[x].append(Tile.Wall)
					tile_map.set_cell(x, y, Tile.Wall)
				elif color == Color(0, 1, 0):
					map[x].append(Tile.Door)
					tile_map.set_cell(x, y, Tile.Door)
				elif color == Color(0, 0, 1):
					map[x].append(Tile.Floor)
					tile_map.set_cell(x, y, Tile.Floor)
					clear_path(Vector2(x, y))
				elif color == Color(1, 0, 1):
					map[x].append(Tile.Ladder)
					tile_map.set_cell(x, y, Tile.Ladder)
					clear_path(Vector2(x, y))
				elif color == Color(0, 1, 1):
					map[x].append(Tile.Hatch)
					tile_map.set_cell(x, y, Tile.Hatch)
					clear_path(Vector2(x, y))
				elif color == Color(1, 1, 0):
					# Enemy!
					var enemy = Enemy.new(self, randi()%2, x, y)
					enemies.append(enemy)
					map[x].append(Tile.Floor)
					tile_map.set_cell(x, y, Tile.Floor)
				else:
					map[x].append(Tile.Stone)
					tile_map.set_cell(x, y, Tile.Stone)
				
				visibility_map.set_cell(x, y, 0)
				
		map_image.unlock()
	
	level_size = Vector2(level_size_x, level_size_y)
	
func _input(event):
	if !event.is_pressed():
		return
	
	if event.is_action("Left"):
		try_move(-1, 0)
	elif event.is_action("Right"):
		try_move(1, 0)
	elif event.is_action("Up"):
		try_move(0, -1)
	elif event.is_action("Down"):
		try_move(0, 1)
		
func clear_path(tile):
	var new_point = enemy_pathfinding.get_available_point_id()
	enemy_pathfinding.add_point(new_point, Vector3(tile.x, tile.y, 0))
	var points_to_connect = []
	
	if tile.x > 0 and map[tile.x - 1][tile.y] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x - 1, tile.y, 0)))
	if tile.y > 0 and map[tile.x][tile.y - 1] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y - 1, 0)))
	if tile.x < level_size.x - 1 and map[tile.x + 1][tile.y] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x + 1, tile.y, 0)))
	if tile.y < level_size.y - 1 and map[tile.x][tile.y + 1] == Tile.Floor:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector3(tile.x, tile.y + 1, 0)))
		
	for point in points_to_connect:
		enemy_pathfinding.connect_points(point, new_point)
	
func try_move(dx, dy):
	var x = player_tile.x + dx
	var y = player_tile.y + dy
	
	var tile_type = Tile.Stone
	if x >= 0 and x < level_size.x and y >= 0 and y < level_size.y:
		tile_type = map[x][y]
	
	match tile_type:
		Tile.Floor:
			var blocked = false
			for enemy in enemies:
				if enemy.tile.x == x and enemy.tile.y == y:
					enemy.take_damage(self, 1)
					if enemy.dead:
						enemy.remove()
						enemies.erase(enemy)
					blocked = true
					break
			
			if !blocked:
				player_tile = Vector2(x, y)
		Tile.Hatch:
			player_tile = Vector2(x, y)
		Tile.Ladder:
			player_tile = Vector2(x, y)			
		Tile.Door:
			set_tile(x, y, Tile.Floor)
		
	for enemy in enemies:
		enemy.act(self)
	
	call_deferred("update_visuals")
		
func set_tile(x, y, tile_type):
	map[x][y] = tile_type
	tile_map.set_cell(x, y, tile_type)
	
	if tile_type == Tile.Floor:
		clear_path(Vector2(x, y))
	
func update_visuals():
	player.position = player_tile * TILE_SIZE
	var player_center = tile_to_pixel_center(player_tile.x, player_tile.y)
	var space_state = get_world_2d().direct_space_state
	
	# get points in radius around player.	
	for x in range(level_size.x):
		for y in range(level_size.y):
			if (player_center.distance_to(tile_to_pixel_center(x, y))/TILE_SIZE) <= PLAYER_VISIBILITY:
				var x_dir = 1 if x < player_tile.x else -1
				var y_dir = 1 if y < player_tile.y else -1
				var test_point = tile_to_pixel_center(x, y) + Vector2(x_dir, y_dir) * TILE_SIZE / 2
				var occlusion = space_state.intersect_ray(player_center, test_point)
				if !occlusion || (occlusion.position - test_point).length() < 1:
					if player_center.distance_to(tile_to_pixel_center(x, y))/TILE_SIZE <= PLAYER_IMMEDIATE_VISIBILITY-0.2:
						visibility_map.set_cell(x, y, -1)
					else:
						visibility_map.set_cell(x, y, 2)
				else:
					visibility_map.set_cell(x, y, 0)
			else:
				visibility_map.set_cell(x, y, 0)
	
	for enemy in enemies:
		enemy.sprite_node.position = enemy.tile * TILE_SIZE
		var enemy_center = tile_to_pixel_center(enemy.tile.x, enemy.tile.y)
		if (player_center.distance_to(enemy_center)/TILE_SIZE) <= PLAYER_VISIBILITY:
			var occlusion = space_state.intersect_ray(player_center, enemy_center)
			if !occlusion:
				enemy.encountered_player = true
				enemy.sprite_node.visible = true
		else:
			enemy.sprite_node.visible = false
			
func tile_to_pixel_center(x, y):
	return Vector2((x + 0.5) * TILE_SIZE, (y + 0.5) * TILE_SIZE)