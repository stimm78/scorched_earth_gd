extends Sprite2D

@onready var tile_map = $"../TileMap"
@onready var sprite_2d = $Sprite2D

var is_moving = false


func _physics_process(delta):
	if is_moving == false:
		return
	if global_position == sprite_2d.global_position:
		is_moving = false
		return
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 3)
	

# func _process(delta):
#	var current_tile: Vector2i = tile_map.local_to_map(global_position)
#	if is_moving:
#		return
#	elif Input.is_action_pressed("west"):
#		move(Vector2.LEFT)
#	elif Input.is_action_pressed("east"):
#		move(Vector2.RIGHT)
#	elif Input.is_action_pressed("northwest"):
#		move(Vector2(-1,-1)) if current_tile.y % 2 == 0 else move(Vector2(0, -1))
#	elif Input.is_action_pressed("northeast"):
#		move(Vector2(0, -1)) if current_tile.y % 2 == 0 else move(Vector2(1, -1))
#	elif Input.is_action_pressed("southwest"):
#		move(Vector2(-1,1)) if current_tile.y % 2 == 0 else move(Vector2(0, 1))
#	elif Input.is_action_pressed("southeast"):
#		move(Vector2(0,1)) if current_tile.y % 2 == 0 else move(Vector2(1, 1))

func _input(event):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	if event is InputEventMouseButton:
		if is_moving:
			return
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var pos_clicked = tile_map.local_to_map(to_local(event.position))
			print(pos_clicked)
			if (pos_clicked == Vector2i(-1, -2)): # northwest
				move(Vector2(-1,-1)) if current_tile.y % 2 == 0 else move(Vector2(0, -1))
			elif (pos_clicked == Vector2i(-2, -1)): # west
				move(Vector2.LEFT)
			elif (pos_clicked == Vector2i(-1, 0)): # southwest
				move(Vector2(-1,1)) if current_tile.y % 2 == 0 else move(Vector2(0, 1))
			elif (pos_clicked == Vector2i(0, 0)): # southeast
				move(Vector2(0,1)) if current_tile.y % 2 == 0 else move(Vector2(1, 1))
			elif (pos_clicked == Vector2i(0, -1)): # east
				move(Vector2.RIGHT)
			elif (pos_clicked == Vector2i(0, -2)): # northeast
				move(Vector2(0, -1)) if current_tile.y % 2 == 0 else move(Vector2(1, -1))
			
			
	
func move(direction: Vector2):
	# get current tile Vector2i
	# get target tile Vector2i
	# get custom data layer from target tile
	# move player
	var current_tile: Vector2 = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if tile_data == null:
		return
	if tile_data.get_custom_data("walkable") == false:
		return
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite_2d.global_position = tile_map.map_to_local(current_tile)
