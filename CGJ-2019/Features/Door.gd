extends Feature

class_name Door


func _on_Door_do_action():
	if Input.is_action_just_pressed("use"):
		# Temporary solution
		queue_free()
		# TODO: Animate the door opening	
