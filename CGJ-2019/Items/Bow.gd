extends "res://Items/Item.gd"
export(PackedScene) var arrow_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE

func set_sprite(sprite):
	.set_sprite(sprite)

func use_item(player, game_world):
	#we want to spawn an arrow in the square in front of the player.
	var offset_pos = game_world.adjacent_tile_world_coord(player.position.x, player.position.y, player.direction)
	
	# check to see if there's an enemy there.
	var enemy = game_world.get_enemy(offset_pos.x, offset_pos.y)
	if enemy:
		enemy.take_damage(5)
	else:
		# Check to see if we can traverse.
		if game_world.traversable(offset_pos.x, offset_pos.y):
			# Spawn the arrow.
			var arrow = arrow_instance.instance()
			arrow.set_damage(5)
			arrow.set_direction(player.direction)
			arrow.position = player.position
			game_world.add_enemy(arrow)
	
#	# add some health to the player.
#	player.heal_damage(10)
#
#	if consumable:
#		usages -= 1
#
#		if usages == 0:
#			consumed = true
#	# we can get the players direction, check if it is using this on a 
#	# door and unlock it.
#	# Don't do anything because we don't care about text for this.
#	return ""