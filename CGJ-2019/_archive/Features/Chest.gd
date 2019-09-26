extends "res://Features/Feature.gd"

export(Array, PackedScene) var items = []
export(bool) var locked = false
export(float) var item_delay = 0.1
export(bool) var stuck = false

var keep_pushing = 0
var amount_to_beat = randi() % 5
var cur_idx = 0
var adding_items = false

func _ready():
	set_process(true)

func _process(delta):
	if adding_items and $Timer.get_time_left() <= 0.1:
		add_items_over_time(cur_idx)
		cur_idx += 1
		$Timer.start(item_delay)

func set_sprite(sprite):
	.set_sprite(sprite)

func open():
	locked = false

func unlock(item):
	if item.type == ProjectGlobals.ITEM_TYPE.Key:
		# return that we've unlocked, and unlock it.
		open()
		return "The key slides nicely into the lock, and you hear a loud click!"
	else:
		return "You can't use " + item.name + " on this object."
		
func interact(player):
	if destroy:
		return ""
	
	if locked:
		return "This object is locked firmly, and requires a key to open"
	else:
		self.player = player
		add_items_over_time(cur_idx)
		cur_idx += 1
		$Timer.start(item_delay)
		adding_items = true
		return "The object opens at the slightest touch, revealing the treasures within..."

func add_items_over_time(idx):
	if idx < items.size():
		var item = items[idx].instance()
		item.icon = item.get_node("Sprite").texture
		print(item)
		spawn_pop_label((position + Vector2(rand_range(0,16) - 8, rand_range(0,8) - 4)), item.name, 1, 50, Color.white)
		player.ui.add_item(item)
	else:
		adding_items = false
		destroy = true