extends "res://Features/Feature.gd"

class_name Barrel

func to_string():
	return "Barrel"


func _on_FeatureBarrel_do_action() -> void:
	Events.emit_signal("prompt_feature", true, "Barrel opened", true, to_string())
	# TODO: Open Inventory OR take all items
	# TODO: Animate opening and closing


func _on_FeatureDepth_body_entered(body : PhysicsBody2D) -> void:
	_set_z_index($FeatureDepth/DepthCollision, body)


# warning-ignore:unused_argument
func _on_FeatureDepth_body_exited(body : PhysicsBody2D) -> void:
	_reset_z_index()


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_entered(area):
	Events.emit_signal("prompt_feature", true, "Open barrel", false, to_string())
	_set_can_be_used(true)


# warning-ignore:unused_argument
func _on_FeatureInteraction_area_exited(area):
	Events.emit_signal("prompt_feature", false, "", false, to_string())
	_set_can_be_used(false)
