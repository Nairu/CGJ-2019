extends StaticBody2D

class_name Feature

signal do_action

onready var collider  =  $FeatureDepth/DepthCollision

export (Globals.Features) var feature_type = Globals.Features.NONE
export var swap_sprite : bool = true

var can_be_used : bool = false

func _ready() -> void:
	if swap_sprite:
		$Sprite.texture = load(Globals.mapped_features[feature_type].keys()[0])
		$FeatureSpriteCollision.shape = load(Globals.mapped_features[feature_type].values()[0])


func _process(delta : float) -> void:
	if can_be_used and Input.is_action_just_pressed("use"):
		emit_signal("do_action")


func _set_z_index(body : CollisionShape2D, other_body : PhysicsBody2D) -> void:
	print("Entered")
	# If the entering body is less than the collider box, then make sure it's above the player.
	if other_body.global_position.y < body.global_position.y:
		self.z_index = 5
	else:
		self.z_index = 0


func _reset_z_index() -> void:
	# Reset Z index.
	self.z_index = 0
	

func _set_can_be_used(toggle : bool) -> void:
	can_be_used = toggle