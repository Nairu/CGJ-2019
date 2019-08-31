extends "res://Enemies/Enemy.gd"
class_name FinalBoss

export(int) var blow_turn_speed = 5
export(int) var shrink_turn_speed = 10
export(Array) var positions
export(int) var damage_fire = 3
export(int) var damage_explosion = 5
export(int) var damage_flamethrower = 2
export(PackedScene) var fireball_anim = load("res://Items/Fireball.tscn")

onready var animator = $Sprite/AnimationPlayer

var shrinking = false
var growing = false

func _ready():
	$HPBar.visible = false
	$MoveBar.visible = false
	
func take_turn(game_manager, player):	
	# we do our own shit here.
	if shrinking or growing:
		return
	
	if cur_turn >= shrink_turn_speed:
		# play the shrink animation, move him to another position, and then play the grow animation.
		animator.play("Shrink")
		shrinking = true
		growing = false
		cur_turn = 0
	elif cur_turn >= blow_turn_speed and position.distance_to(player.position) < 128:
		cur_turn -= 1
		var fireball = fireball_anim.instance()
		fireball.position = position
		game_manager.add_enemy(fireball)
	else:
		cur_turn += 1
	#.take_turn(game_manager, player)

func _process(delta):
	if shrinking:
		if animator.is_playing() == false:
			# We've finished shrinking, so move us and start the next animation.
			positions.shuffle()
			position = positions.front()
			tile = position/ProjectGlobals.TILE_SIZE
			animator.queue("Appear")
			shrinking = false
			growing = true
	
	if growing:
		if animator.is_playing() == false:
			growing = false
			animator.play("Idle_Enemy")

func take_damage(damage):
	spawn_pop_label((position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)), str(damage), 0.5, 3)

	.take_damage(damage)

	if is_dead():
		spawn_items()