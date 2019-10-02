extends "res://Features/Feature.gd"

class_name Bed

func to_string():
	return "Bed"


func _on_FeatureBed_do_action() -> void:
	Events.emit_signal("prompt_feature", true, "Touched bed", true, to_string())
	# TODO: Open Inventory OR take all items
	# TODO: Animate opening and closing


# warning-ignore:unused_argument
func _on_FeatureDepth_body_entered(body : PhysicsBody2D) ->  void:
	_set_z_index($FeatureDepth/DepthCollision, body)


# warning-ignore:unused_argument
func _on_FeatureDepth_body_exited(body : PhysicsBody2D) ->  void:
	_reset_z_index()


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_entered(area):
	Events.emit_signal("prompt_feature", true, "Interact with bed", false, to_string())
	_set_can_be_used(true)


func _on_FeatureInteraction_area_exited(area):
	Events.emit_signal("prompt_feature", false, "", false, to_string())
	_set_can_be_used(false)
