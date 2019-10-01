extends Node

enum Features { NONE = -1, CHEST, BARREL, BED, WARDROBE }

export (Array, Dictionary) var feature_swap
export var mapped_features : Dictionary

func _ready() -> void:
	_generate_randomised_feature_pool()


func _generate_randomised_feature_pool() -> void:
	# Populate paths for matching Sprite and CollisionShape2D
	feature_swap.push_back({"res://Sprites/Features/barrel.png": "res://Features/FeatureCollisions/FeatureBarrelCollision.tres"})
	feature_swap.push_back({"res://Sprites/Features/bed.png": "res://Features/FeatureCollisions/FeatureBedCollisions.tres"})
	feature_swap.push_back({"res://Sprites/Features/chest-closed-front.png": "res://Features/FeatureCollisions/FeatureChestCollisions.tres"})

	# Now associate a feature sprite with each unique feature type.
	for feature in Features:
		if not feature_swap.empty():
			if Features[feature] != Features.NONE:
				var random = RandomNumberGenerator.new()
				random.randomize()
	
				for i in random.randi_range(2, 5):
					feature_swap.shuffle()
	
				if not mapped_features.has(Features[feature]):
					mapped_features[Features[feature]] = feature_swap[0]
					feature_swap.pop_front()

