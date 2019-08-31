extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("Play")

func _process(delta):
	if not $Sprite/AnimationPlayer.is_playing():
		queue_free()
		
func set_direction(direction):
	match direction:
		ProjectGlobals.CARDINALITY.East:
			$Sprite.rotation_degrees = 0
		ProjectGlobals.CARDINALITY.South:
			$Sprite.rotation_degrees = 90
		ProjectGlobals.CARDINALITY.West:
			$Sprite.rotation_degrees = 180
		ProjectGlobals.CARDINALITY.North:
			$Sprite.rotation_degrees = 270