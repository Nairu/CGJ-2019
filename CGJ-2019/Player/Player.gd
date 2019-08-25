extends KinematicBody2D

const MOVE_SPEED = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
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
	position += Vector2(dx, dy) * MOVE_SPEED