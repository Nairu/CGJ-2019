extends "res://Enemies/Enemy.gd"
class_name EnemyMimfle
var mimfle_visible = false

# Called when the node enters the scene tree for the first time.

func _ready():
	$HPBar.visible = false
	$MoveBar.visible = false
	
func take_turn(game_manager, player):
	if path.size() <= 4 and mimfle_visible == false:
		become_visible()
	
	if not mimfle_visible:
		return
	
	.take_turn(game_manager, player)

func take_damage(damage):
	spawn_pop_label((position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)), str(damage), 0.5, 3)

	.take_damage(damage)

	if is_dead():
		spawn_items()
		
func become_visible():
	update_position(path[1].x, path[1].y)
	visible = true
	$Sprite/AnimationPlayer.play("Idle")
	$HPBar.visible = true
	$MoveBar.visible = true
	mimfle_visible = true
	$Noise.stream = load("res://Audio/SFX/Monster Growl.ogg")
	$Noise.play()