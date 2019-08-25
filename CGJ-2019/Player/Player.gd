extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 32 # Pixels/second
const MOVE_DELAY = .15

var move_time = 0

func _physics_process(delta):
	if move_time >= MOVE_DELAY:
		move_time = 0
		var motion = Vector2()
		
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
		
		motion = motion.normalized() * MOTION_SPEED
		
		#move_and_slide(motion)
		var col = move_and_collide(motion, true, true, true)
		
		if not col:
			move_and_collide(motion)
		else:
			if col.collider is TileMap:
				print(col.position)
				var map = get_parent().get_node("Doors") as TileMap
				var cell_location = map.world_to_map(col.position)
				var cell = map.get_cell(cell_location.x, cell_location.y)
				
			#var cell = col.collider.get_class().get_cell(col.position.x, col.position.y)

			#print(col.tile_set.tile_get_shape_one_way(cell, 0))
			
			#if collider.tile_set.tile_get_shape_one_way(cell, 0):
	move_time += delta