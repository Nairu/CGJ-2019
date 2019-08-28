extends "res://Items/Item.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	tile = position / ProjectGlobals.TILE_SIZE

func set_sprite(sprite):
	.set_sprite(sprite)

func use_item(player, game_world):
	
	# add some health to the player.
	player.heal_damage(10)
	
	if consumable:
		usages -= 1
		
		if usages == 0:
			consumed = true
	# we can get the players direction, check if it is using this on a 
	# door and unlock it.
	# Don't do anything because we don't care about text for this.
	return ""