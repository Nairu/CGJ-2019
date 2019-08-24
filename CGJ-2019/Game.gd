extends Node2D

# Constant Values -------------------------------------------------
const TILE_SIZE = 32
enum Tile {Door, Floor, Wall, Stone}
var map_image = preload("res://Maps/MapTest1.png")

# Current Level ---------------------------------------------------
var level_num = 0
var map = []

# Node References -------------------------------------------------
onready var tile_map = $TileMap
onready var player = $Player

# Game State ------------------------------------------------------
var player_tile = Vector2(0,0)
var score = 0

# Functions -------------------------------------------------------


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(1280, 720))
	build_level()
	update_visuals()
	
func build_level():
	map.clear()
	tile_map.clear()
	
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
				print (color)
				if color.r8 == 255 and color.g8 == 255 and color.b8 == 255:
					player_tile = Vector2(x, y)
					map[x].append(Tile.Floor)
					tile_map.set_cell(x, y, Tile.Floor)
				elif color.r8 == 255:
					map[x].append(Tile.Wall)
					tile_map.set_cell(x, y, Tile.Wall)
				elif color.g8 == 255:
					map[x].append(Tile.Door)
					tile_map.set_cell(x, y, Tile.Door)
				elif color.b8 == 255:
					map[x].append(Tile.Floor)
					tile_map.set_cell(x, y, Tile.Floor)
				else:
					map[x].append(Tile.Stone)
					tile_map.set_cell(x, y, Tile.Stone)
		map_image.unlock()
		
func _input(event):
	if !event.is_pressed():
		return
	
	if event.is_action("Left"):
		try_move(-1, 0)
	elif event.is_action("Right"):
		try_move(1, 0)
	elif event.is_action("Up"):
		try_move(-1, 0)
	elif event.is_action("Down"):
		try_move(1, 0)
		
func try_move(dx, dy):
	var x = player_tile.x + dx
	var y = player_tile.y + dy
		
func update_visuals():
	player.position = player_tile * TILE_SIZE