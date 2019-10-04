extends KinematicBody2D

enum Movements { NORMAL, PACED }

onready var inventory : Control = $CanvasLayer/InventorySystem

export (float) var speed = 200
export (Movements) var move_mode = Movements.NORMAL

var move_direction : Vector2

const MOVE_DELAY := .2
var move_count : float = 0

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()
		
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("use"):
		pass
		
	if event.is_action_pressed("inventory"):
		if not inventory.visible:
			inventory.reset_selection()
		inventory.visible = !inventory.visible

func _physics_process(delta):
	_handle_weapon()
	
	if move_mode == Movements.NORMAL:
		_do_movement(delta)
	else:
		_do_paced_movement(delta)
	pass	
	
	
func _do_paced_movement(delta: float) -> void:
	if 	move_direction == Vector2.ZERO:
		if Input.is_action_pressed("left"):
			move_direction.x = -32
		elif Input.is_action_pressed("right"):
			move_direction.x = 32
		else:
			move_direction.x = 0
	
		if Input.is_action_pressed("up"):
			move_direction.y = -32
		elif Input.is_action_pressed("down"):
			move_direction.y = 32
		else:
			move_direction.y = 0			
	else:
		move_count += delta
		
		if move_count >= MOVE_DELAY:
			move_count = 0
			if not move_and_collide(move_direction, true, true, true):
				position += move_direction
			move_direction = Vector2.ZERO
	
func _do_movement(delta: float) -> void:
	if Input.is_action_pressed("left"):
		move_direction.x = -speed
	elif Input.is_action_pressed("right"):
		move_direction.x = speed
	else:
		move_direction.x = 0

	if Input.is_action_pressed("up"):
		move_direction.y = -speed
	elif Input.is_action_pressed("down"):
		move_direction.y = speed
	else:
		move_direction.y = 0
	move_and_slide(move_direction)
	move_direction = Vector2.ZERO


onready var weapon_distance = $Weapon.position.length()


func _handle_weapon() -> void:
	var angle = get_local_mouse_position().angle()
	
	$Weapon.position.x = cos(angle) * weapon_distance
	$Weapon.position.y = sin(angle) * weapon_distance
	$Weapon.rotation = angle
#	if $Weapon/sprite:
#		$Weapon/sprite.rotation = -45