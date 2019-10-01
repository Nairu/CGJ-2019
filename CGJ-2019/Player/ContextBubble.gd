extends Area2D


func _on_ContextBubble_area_entered(area):
	self.visible = true


func _on_ContextBubble_area_exited(area):
	self.visible = false
