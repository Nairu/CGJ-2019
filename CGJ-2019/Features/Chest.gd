extends "res://Features/Feature.gd"

export(Array) var items = []

export(bool) var locked = false

var keep_pushing = 0
var amount_to_beat = randi() % 5

func set_sprite(sprite):
	.set_sprite(sprite)

func open():
	locked = false

func unlock(item):
	if item.type == Globals.ITEM_TYPE.Key:
		# return that we've unlocked, and unlock it.
		open()
		return "The key slides nicely into the lock, and you hear a loud click!"
	else:
		return "You don't this you can use " + item.name + " on this object."

func interact(player):
	if locked:
		return "This object is locked firmly, and requires a key to open"
	else:
		for path in items:
			var item = load(path).instance()
			item.icon = item.get_node("Sprite").texture
			player.ui.add_item(item)
			destroy = true
		return "The object opens at the slightest touch, revealing the treasures within..."