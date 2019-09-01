extends "res://Features/Feature.gd"

export(PackedScene) var food
export(float) var spawn_chance

func set_sprite(sprite):
	.set_sprite(sprite)

func interact(player):
	if randf() <= spawn_chance:
		var item = food.instance()
		item.icon = item.get_node("Sprite").texture
		player.ui.add_item(item)
		spawn_chance = -1
		return "The stout wooden object contains some old food, which still looks edible..."
	else:
		return "The barrel is empty."