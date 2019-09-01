extends KinematicBody2D
class_name EnemyBase

export(int) var max_health = 10
export(int) var damage = 1
export(int) var turn_speed = 2
export(PackedScene) var pop_label = load("res://Util/pop_label.tscn")
export(Array) var damage_noises
export(Array) var potential_item_drops
export(float) var item_drop_chance = 0.2

onready var GameManager = get_node("/root/GameScene")
onready var tween = $AnimationTween
onready var tween_move = $MoveBarTween
onready var health_bar = $HPBar
onready var move_bar = $MoveBar
onready var current_health = max_health
onready var noise = $Noise
onready var tile = position / ProjectGlobals.TILE_SIZE

var dead = false
var ignores_path = false
var path = null
var cur_turn = 0
var on_screen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("Idle")
	
func take_turn(game_manager, player):
	if cur_turn >= turn_speed:
		if path:			
			if path.size() > 2:
				if GameManager.path_blocked_by_feature(path):
					cur_turn=0
					return
				
				if (GameManager.traversable(path[1].x, path[1].y)):
					update_position(path[1].x, path[1].y)
					path.remove(1)
			else:
				player.take_damage(damage)
		cur_turn=0
	else:
		cur_turn+=1
	
	if turn_speed > 0:
		tween_move.interpolate_property(move_bar, "rect_size", move_bar.rect_size, Vector2(ProjectGlobals.TILE_SIZE - ProjectGlobals.TILE_SIZE * cur_turn / turn_speed, 2), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween_move.start()

func take_damage(damage):
	if damage_noises.size() > 0:
		damage_noises.shuffle()
		play_noise(damage_noises.front())

	current_health = max(0, current_health - damage)
	health_bar.rect_size.x = ProjectGlobals.TILE_SIZE * current_health / max_health
	dead = current_health == 0
	
func play_noise(sound):
	noise.stream = sound
	noise.play()

func is_dead():
	return dead

func spawn_items():
	print("Calling spawn_items")
	if randf() <= item_drop_chance and potential_item_drops.size() > 0:
		potential_item_drops.shuffle()
		var item_inst = load(potential_item_drops[0]).instance()
		print("Spawning item: " + str(item_inst))
		item_inst.position = position
		item_inst._ready()
		get_node("/root/GameScene/Items").add_item(item_inst)

func spawn_pop_label(position, text, duration, distance, color=Color.red):
	var label_instance = pop_label.instance()
	label_instance.position = position
	label_instance.text = text
	label_instance.duration = duration
	label_instance.float_distance = distance
	get_parent().add_child(label_instance)
	label_instance.pop()

func update_position(x, y):	
	tile = Vector2(x,y) / ProjectGlobals.TILE_SIZE
	tween.interpolate_property(self, "position", position, Vector2(x,y), 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	