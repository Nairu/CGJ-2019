extends "res://Items/Item.gd"

export(int) var dam_min = 1
export(int) var dam_max = 3
var enemy = null

func set_sprite(sprite):
	.set_sprite(sprite)
	
func use_item(player, game_world):
	#enemy.take_damage(int(rand_range(dam_min, dam_max)))
	var target_position = game_world.adjacent_tile_world_coord(player.position.x, player.position.y, player.direction)
	enemy = game_world.get_enemy(target_position.x, target_position.y)
	if enemy:
		enemy.take_damage(int(rand_range(dam_min, dam_max)))
		enemy.take_damage(int(rand_range(dam_min, dam_max)))
	
	return ""