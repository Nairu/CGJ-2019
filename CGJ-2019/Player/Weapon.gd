extends Position2D


onready var tween := $Tween


func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass


func _physics_process(delta: float) -> void:
	_handle_attack()


func _handle_attack() -> void:
	if Input.is_action_just_pressed("attack") and not tween.is_active():
		
		var destination = position + Vector2.UP * 10
		
		print(position)
		print(position + (transform.x * 10))
		
#		print(destination)
#
		tween.interpolate_property(self,
			"position",
			position,
			position + (transform.x * 10), 0.25,
			Tween.TRANS_QUAD,
			Tween.EASE_IN)
		tween.start()