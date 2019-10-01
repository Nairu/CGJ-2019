extends "res://Features/Feature.gd"

class_name Door


func _on_FeatureDoor_do_action() -> void:
	print("Door used")
	# Temporary solution
	queue_free()
	# TODO: Animate the door opening


func _on_FeatureDepth_body_entered(body : PhysicsBody2D) -> void:
	_set_z_index($FeatureDepth/DepthCollision, body)


# warning-ignore:unused_argument
func _on_FeatureDepth_body_exited(body : PhysicsBody2D) -> void:
	_reset_z_index()


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_entered(area):
	_set_can_be_used(true)


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_exited(area):
	_set_can_be_used(false)
