extends "res://Enemies/Enemy.gd"
class_name EnemyBookcase

export(bool) var transformed = false

## Called when the node enters the scene tree for the first time.
func _ready():
	$HPBar.visible = false
	$MoveBar.visible = false
	$Sprite.offset = Vector2(0, 4)
	$Shadow.offset = Vector2(0, 2)

func take_turn(game_manager, player):
	if path.size() == 2:
		# the player is next to us, transform.
		transform()
		
	if !transformed:
		return
	
	.take_turn(game_manager, player)

func take_damage(damage):
	transform()
	spawn_pop_label((position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)), str(damage), 0.5, 3)
	
	.take_damage(damage)

	if is_dead():
		spawn_items()
	
func transform():
	$HPBar.visible = true
	$MoveBar.visible = true
	$Sprite/AnimationPlayer.queue("rise")
	$Sprite/AnimationPlayer.queue("idle_float")
	transformed = true