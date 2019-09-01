extends TileMap

onready var astar = AStar.new()
onready var traversable_tiles = get_used_cells()
onready var used_rect = get_used_rect()

func _ready():
	_add_traversable_tiles(traversable_tiles)
	_connect_traversable_tiles(traversable_tiles)
	
func _add_traversable_tiles(traversable_tiles):
	for tile in traversable_tiles:
		var id = _get_id_for_point(tile)
		astar.add_point(id, Vector3(tile.x, tile.y, 0))
		
export(bool) var final_room = false
func _connect_traversable_tiles(traversable_tiles):
	if !final_room:
		for tile in traversable_tiles:
			var id = _get_id_for_point(tile)
			# Do north, south, east and west
			var target = tile + Vector2(-1, 0)
			var target_id = _get_id_for_point(target)
			if tile != target and astar.has_point(target_id):
				astar.connect_points(id, target_id, true)
			
			target = tile + Vector2(1, 0)
			target_id = _get_id_for_point(target)
			if tile != target and astar.has_point(target_id):
				astar.connect_points(id, target_id, true)
			
			target = tile + Vector2(0, 1)
			target_id = _get_id_for_point(target)
			if tile != target and astar.has_point(target_id):
				astar.connect_points(id, target_id, true)
			
			target = tile + Vector2(0, 1)
			target_id = _get_id_for_point(target)
			if tile != target and astar.has_point(target_id):
				astar.connect_points(id, target_id, true)
	else:
		for tile in traversable_tiles:
			var id = _get_id_for_point(tile)
			
			for x in range(3):
				for y in range(3):
					if tile.x == x and tile.y == y:
						pass
					else:
						var target = tile + Vector2(x - 1, y - 1)
						var target_id = _get_id_for_point(target)
						if tile != target and astar.has_point(target_id):
							astar.connect_points(id, target_id, true)

func _get_id_for_point(point):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x
	
func enable_points():
	for point in astar.get_points():
		astar.set_point_disabled(point, false)
	
func set_point_disabled(point, disabled):
	var id = _get_id_for_point(point)
	if astar.has_point(id):
		astar.set_point_disabled(id, disabled)

func get_astar_path(start, end):
	# Convert positions to cell coordinates
	var start_tile = world_to_map(start)
	var end_tile = world_to_map(end)

	# Determines IDs
	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)

	# Return null if navigation is impossible
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return null

	# Otherwise, find the map
	var path_map = astar.get_point_path(start_id, end_id)

	# Convert Vector3 array (remember, AStar is 3D) to real world points
	var path_world = []
	for point in path_map:
		var point_world = .map_to_world(Vector2(point.x, point.y))
		path_world.append(point_world)
	return path_world
