extends Node

enum Features { NONE = -1, CHEST, BARREL, BED, BOOKCASE }

export (Array, Array) var mapped_features
export (Array, StreamTexture) var sprite_poole

func _ready() -> void:
	_generate_sprite_pool()


func _generate_sprite_pool() -> void:
	# Populate the StreamTextureList
	sprite_poole.push_back(load("res://Sprites/barrel.png"))
	sprite_poole.push_back(load("res://Sprites/bed.png"))
	sprite_poole.push_back(load("res://Sprites/bookcase-front.png"))
	sprite_poole.push_back(load("res://Sprites/chest-closed-front.png"))
	sprite_poole.push_back(load("res://Sprites/chest-of-drawers-front.png"))

	# Now associate a sprite with each unique object type.
	for feature in Features:
		if Features[feature] != Features.NONE:
			var random = RandomNumberGenerator.new()
			random.randomize()

			for i in random.randi_range(2, 5):
				sprite_poole.shuffle()

			if not mapped_features[Features[feature]]:
				Globals.mapped_features[Features[feature]] = Globals.sprite_list[0]
				Globals.sprite_list.pop_front()

