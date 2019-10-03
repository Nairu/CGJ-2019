extends Node
class_name Item

export (String) var sprite
export (String) var title
export (String) var description


func set_sprite(texture_path : String) -> void:
	sprite = texture_path