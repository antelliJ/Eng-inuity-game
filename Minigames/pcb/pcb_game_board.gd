extends Node2D

@export var cell_size : float = 64.0
@export var grid_width : int = 5
@export var grid_height : int = 5

var is_drawing : bool = false
var current_path: Array[Vector2i] = []
var active_color : Color = Color.RED

@onready var path_line: Line2D = $PathLine

func _ready() -> void:
	path_line.default_color = active_color
	path_line.width = cell_size * 0.4
	path_line.joint_mode = Line2D.LINE_JOINT_ROUND
	path_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	path_line.end_cap_mode = Line2D.LINE_CAP_ROUND

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		var grid_pos = screen_to_grid(get_local_mouse_position())
		if is_within_bounds(grid_pos):
			# TODO: only start if grid_pos has a starting dot
			is_drawing = true
			current_path = [grid_pos]
			update_visual_line(get_local_mouse_position())

	elif event.is_action_released("Click"):
		if is_drawing:
			is_drawing = false
			update_visual_line(Vector2.INF) # remove the tail
			# TODO: validate if path connects to target
			print("Finished path: ", current_path)

	elif event is InputEventMouseMotion and is_drawing:
		var mouse_pos = get_local_mouse_position()
		extend_path_toward(mouse_pos)
		update_visual_line(mouse_pos)

func extend_path_toward(mouse_pos: Vector2) -> void:
	# Walk one cell at a time toward the mouse until we reach it or get blocked.
	# The counter is a safety net against infinite loops.
	for i in range(64):
		var last_cell: Vector2i = current_path.back()
		var offset = mouse_pos - grid_to_screen(last_cell)

		# Mouse is still inside the last cell: nothing to do
		if absf(offset.x) <= cell_size * 0.5 and absf(offset.y) <= cell_size * 0.5:
			return

		# Step along whichever axis the mouse is farthest from (no diagonals)
		var step := Vector2i.ZERO
		if absf(offset.x) > absf(offset.y):
			step.x = int(signf(offset.x))
		else:
			step.y = int(signf(offset.y))
		var next_cell = last_cell + step

		if not is_within_bounds(next_cell):
			return  # mouse is outside the grid; stay at the edge

		# Going backwards: trim
		if current_path.size() > 1 and next_cell == current_path[-2]:
			current_path.pop_back()
			continue

		# Ran into our own path: cut back to that cell (Flow Free behavior)
		if current_path.has(next_cell):
			while current_path.back() != next_cell:
				current_path.pop_back()
			continue

		# TODO: return here if next_cell is occupied by another color
		current_path.append(next_cell)

func screen_to_grid(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x / cell_size), floori(pos.y / cell_size))

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	return (Vector2(grid_pos) + Vector2(0.5, 0.5)) * cell_size

func is_within_bounds(grid_pos: Vector2i) -> bool:
	return grid_pos.x >= 0 and grid_pos.x < grid_width \
		and grid_pos.y >= 0 and grid_pos.y < grid_height

func update_visual_line(mouse_pos: Vector2) -> void:
	path_line.clear_points()
	for cell in current_path:
		path_line.add_point(grid_to_screen(cell))
	# Small "tail" that leans toward the mouse, so the line feels attached to the cursor
	if is_drawing and mouse_pos != Vector2.INF:
		var last_center = grid_to_screen(current_path.back())
		var tail = (mouse_pos - last_center).limit_length(cell_size * 0.5)
		path_line.add_point(last_center + tail)
