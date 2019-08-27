extends KinematicBody2D
class_name EnemyBookcase

export(int) var max_health = 10
export(PackedScene) var pop_label = load("res://Util/pop_label.tscn")

onready var GameManager = get_node("/root/GameScene")
onready var tween = $AnimationTween
onready var tween_move = $MoveBarTween
onready var health_bar = $HPBar
onready var current_health = max_health
onready var move_bar = $MoveBar

var dead = false

var turn_speed = 1
var path
onready var tile = position / ProjectGlobals.TILE_SIZE
var pixel_snapping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Sprite/AnimationPlayer.set_blend_time("rise", "idle_float", 0.4)
	#$Sprite/AnimationPlayer.queue("rise")
	$Sprite/AnimationPlayer.queue("idle_float")
	#tween.interpolate_property(self, "position", position, Vector2(x,y), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()

var cur_turn = 0
func take_turn(player):
	#GameManager.set_point_disabled(position.x, position.y, true)
	if cur_turn >= turn_speed:
		if path:
			if path.size() > 2:
				if (GameManager.traversable(path[1].x, path[1].y)):
					update_position(path[1].x, path[1].y)
					path.remove(1)
			else:
				player.take_damage(1)
		cur_turn=0
	else:
		cur_turn+=1
	#anticipation.color.a8 = cur_turn * (float(cur_turn) / float(turn_speed) * 150)
	tween_move.interpolate_property(move_bar, "rect_size", move_bar.rect_size, Vector2(ProjectGlobals.TILE_SIZE - ProjectGlobals.TILE_SIZE * cur_turn / turn_speed, 2), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_move.start()

func take_damage(damage):
	var label_instance = pop_label.instance()
	label_instance.position = position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)
	label_instance.text = str(damage)
	label_instance.duration = 0.5
	label_instance.float_distance = 3
	label_instance.final_scale = Vector2(1.2, 1.2)
	get_parent().add_child(label_instance)
	label_instance.pop()
	
	current_health = max(0, current_health - damage)
	health_bar.rect_size.x = ProjectGlobals.TILE_SIZE * current_health / max_health
	dead = current_health == 0
	
func update_position(x, y):	
	tile = Vector2(x,y) / ProjectGlobals.TILE_SIZE
	tween.interpolate_property(self, "position", position, Vector2(x,y), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#self.position = path[1]
	