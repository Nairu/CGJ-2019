extends KinematicBody2D
class_name EnemyBookcase

export(int) var max_health = 10

onready var GameManager = get_node("/root/GameScene")
onready var tween = $AnimationTween
onready var health_bar = $HPBar
onready var current_health = max_health
var dead = false

var turn_speed = 1
var path
onready var tile = position / Globals.TILE_SIZE

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.set_blend_time("rise", "idle_float", 0.4)
	$Sprite/AnimationPlayer.queue("rise")
	$Sprite/AnimationPlayer.queue("idle_float")
	
var cur_turn = 0
func take_turn(player):
	#GameManager.set_point_disabled(position.x, position.y, true)
	if cur_turn >= turn_speed:
		print("Taking my turn~")
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

func take_damage(damage):
	current_health = max(0, current_health - damage)
	health_bar.rect_size.x = Globals.TILE_SIZE * current_health / max_health
	dead = current_health == 0
	
func update_position(x, y):	
	tile = Vector2(x,y) / Globals.TILE_SIZE
	tween.interpolate_property(self, "position", position, Vector2(x,y), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#self.position = path[1]
	