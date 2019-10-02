extends "res://Features/Feature.gd"

class_name Door

func to_string():
	return "Door"


func _on_FeatureDoor_do_action() -> void:
	Events.emit_signal("prompt_feature", true, "Door opened", true, to_string())
	hidden = true
	# Temporary solution
	queue_free()
	# TODO: Animate the door opening


func _on_FeatureDepth_body_entered(body : PhysicsBody2D) -> void:
	_set_z_index($FeatureDepth/DepthCollision, body)


# warning-ignore:unused_argument
func _on_FeatureDepth_body_exited(body : PhysicsBody2D) -> void:
	_reset_z_index()


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_entered(area : Area2D) -> void:
	Events.emit_signal("prompt_feature", true, "Open door", false, to_string())
	_set_can_be_used(true)


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_exited(area : Area2D) -> void:
	if not hidden:
		Events.emit_signal("prompt_feature", false, "", false, to_string())
	_set_can_be_used(false)
