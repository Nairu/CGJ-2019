extends StaticBody2D

class_name Feature

signal do_action

onready var ColliderBox = $InteractionCollision

export (Globals.Features) var feature_type = Globals.Features.NONE
export var swap_sprite : bool = true

var can_be_used : bool = false


func _ready():
	if swap_sprite:
		$Sprite.texture = Globals.mapped_features[feature_type]


func _process(delta : float) -> void:
	if can_be_used and Input.is_action_just_pressed("use"):
			emit_signal("do_action")
			print("do_action")


func _on_InteractionTrigger_body_entered(body : PhysicsBody2D) -> void:
	# Confirm the other Object is not null.
	if body:
		can_be_used = true
		# If the entering body is less than the collider box, then make sure it's above the player.
		if body.global_position.y < ColliderBox.global_position.y:
			self.z_index = 5
		else:
			self.z_index = 0


func _on_InteractionTrigger_body_exited(body : PhysicsBody2D) -> void:
	can_be_used = false
	# Reset Z index.
	self.z_index = 0

