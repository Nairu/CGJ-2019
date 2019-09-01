extends "res://Enemies/Enemy.gd"
class_name EnemySplooge

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("Idle")
	
func take_turn(game_manager, player):
	.take_turn(game_manager, player)

func take_damage(damage):
	spawn_pop_label((position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)), str(damage), 0.5, 3)

	.take_damage(damage)

	if is_dead():
		spawn_items()