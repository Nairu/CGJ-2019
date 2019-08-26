extends KinematicBody2D

var turn_speed = 2
var path

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("Idle")
	
var cur_turn = 0
func take_turn():
	if cur_turn >= turn_speed:
		print("Taking my turn~")
		if path and path.size() > 1:
			self.position = path[1]
			path.remove(1)
		cur_turn=0
	else:
		cur_turn+=1