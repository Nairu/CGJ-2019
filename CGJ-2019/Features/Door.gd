extends "res://Features/Feature.gd"

export(bool) var locked = false
export(bool) var stuck = false

var keep_pushing = 0
var amount_to_beat = randi() % 5

func set_sprite(sprite):
	.set_sprite(sprite)

func open():
	locked = false
	stuck = false

func unlock(item):
	if item.type == Globals.ITEM_TYPE.Key:
		# return that we've unlocked, and unlock it.
		open()
		return "The key slides nicely into the lock, and you hear a loud click!"
	else:
		return "You don't this you can use " + item.name + " on this object."

func interact():
	if stuck:
		keep_pushing += 1
		if keep_pushing < amount_to_beat:
			return "This object appears sturdy, but repeated pushes might open it"
		else:
			open()
			return "The lock gives out!"
	elif locked:
		return "This object is locked firmly, and requires a key to open"
	else:
		destroy = true
		return "It moves at your push..."