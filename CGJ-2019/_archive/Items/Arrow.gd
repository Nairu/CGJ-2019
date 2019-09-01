extends Node2D

onready var tween = $Tween

var dead = false
var damage = 2
var direction
var tile
var ignores_path = true
var path

func set_direction(direction):
	self.direction = direction
	match direction:
		ProjectGlobals.CARDINALITY.East:
			$Sprite.rotation_degrees = 0
		ProjectGlobals.CARDINALITY.South:
			$Sprite.rotation_degrees = 90
		ProjectGlobals.CARDINALITY.West:
			$Sprite.rotation_degrees = 180
		ProjectGlobals.CARDINALITY.North:
			$Sprite.rotation_degrees = 270

func set_damage(damage):
	self.damage = damage
	
func take_turn(game_manager, player):
	var offset = game_manager.adjacent_tile_world_coord(position.x, position.y, direction)
	# check for enemies first, then check for traversable.
	var enemy = game_manager.get_enemy(offset.x, offset.y)
	if enemy and not enemy.has_method("set_direction"):
		enemy.take_damage(damage)
		dead = true
	elif game_manager.traversable(offset.x, offset.y, true):
		# Move us across one tile.
		update_position(offset.x, offset.y)
	else:
		dead = true

func update_position(x, y):
	tile = Vector2(x,y) / ProjectGlobals.TILE_SIZE
	tween.interpolate_property(self, "position", position, Vector2(x,y), 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#self.position = path[1]
	
func take_damage(damage):
	pass

##class_name Item
#
#onready var tile = position / ProjectGlobals.TILE_SIZE
#onready var icon = $Sprite.texture
#export(ProjectGlobals.ITEM_TYPE) var type
#
#var consumed = false
#
#export(bool) var consumable = true
#export(int) var usages = 1
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	tile = position / ProjectGlobals.TILE_SIZE
#	icon = $Sprite.texture
#
#func set_sprite(sprite):
#	$Sprite.texture = sprite
#	icon = sprite
#
#func use_item(player, game_world):
#	if consumable:
#		usages -= 1
#
#		if usages == 0:
#			consumed = true
#	# we can get the players direction, check if it is using this on a 
#	# door and unlock it.
#	return "Player used item " + name