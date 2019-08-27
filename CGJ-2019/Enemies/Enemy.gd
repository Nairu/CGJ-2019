extends KinematicBody2D
class_name EnemyBase

export(int) var max_health = 10

onready var GameManager = get_node("/root/GameScene")
onready var tween = $AnimationTween
onready var tween_move = $MoveBarTween
onready var health_bar = $HPBar
onready var move_bar = $MoveBar
onready var current_health = max_health

var dead = false

var turn_speed = 2
var path
onready var tile = position / ProjectGlobals.TILE_SIZE

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("Idle")
	
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
				# check to see if the next tile is still the players.
				player.take_damage(1)
		cur_turn=0
	else:
		cur_turn+=1
	tween_move.interpolate_property(move_bar, "rect_size", move_bar.rect_size, Vector2(ProjectGlobals.TILE_SIZE - ProjectGlobals.TILE_SIZE * cur_turn / turn_speed, 2), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_move.start()

func take_damage(damage):
	current_health = max(0, current_health - damage)
	health_bar.rect_size.x = ProjectGlobals.TILE_SIZE * current_health / max_health
	dead = current_health == 0
	
func update_position(x, y):	
	tile = Vector2(x,y) / ProjectGlobals.TILE_SIZE
	tween.interpolate_property(self, "position", position, Vector2(x,y), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#self.position = path[1]
	