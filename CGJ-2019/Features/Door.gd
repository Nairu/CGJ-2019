extends "res://Features/Feature.gd"

export(bool) var locked = false

var keep_pushing = 0
var amount_to_beat = randi() % 5

func unlock():
	locked = false

func interact():
	if locked:
		keep_pushing += 1
		if keep_pushing < amount_to_beat:
			return "This is a strong door"
		else:
			unlock()
			return "The lock gives out!"
	else:
		destroy = true
		return "The door opens at your push..."