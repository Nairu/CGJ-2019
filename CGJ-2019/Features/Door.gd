extends "res://Features/Feature.gd"

class_name Door

func _ready():
	$Timer.connect("timeout", self, "_on_timer_end")

func _on_FeatureDoor_do_action() -> void:
	Events.emit_signal("prompt_feature", "Door opened", true, true)
	$Timer.start(1)
	# Temporary solution
	#queue_free()
	# TODO: Animate the door opening


func _on_FeatureDepth_body_entered(body : PhysicsBody2D) -> void:
	_set_z_index($FeatureDepth/DepthCollision, body)


# warning-ignore:unused_argument
func _on_FeatureDepth_body_exited(body : PhysicsBody2D) -> void:
	_reset_z_index()


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_entered(area):
	Events.emit_signal("prompt_feature", "Open door", true, false)
	_set_can_be_used(true)


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_exited(area):
	Events.emit_signal("prompt_feature", "", false, false)
	_set_can_be_used(false)


func _on_timer_end() -> void:
	queue_free()