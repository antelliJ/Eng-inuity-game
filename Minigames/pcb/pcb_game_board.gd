extends Node2D

@export var cell_size : float = 64.0
@export var grid_width : int = 5
@export var grid_height : int = 5


@export var all_pairs : Array[FlowPair] = []
var pairs : Array[FlowPair] = []

@export_group("Obstacles")
@export var board_sprite : Sprite2D
@export_range(0.0, 1.0) var dark_threshold := 0.32
@export_range(0.0,1.0) var clearance := 0.6
@export var debug_draw := true

var obstacles := ObstacleMap.new()
var paths : Array = []
var lines : Array[Line2D]
var overlay: Node2D # to draw endpoint dot on lines
var active_index := -1 # the pair that is currently being drawn, -1 for none

var is_drawing : bool = false
#var current_path: Array[Vector2i] = []
var active_color : Color = Color.RED

var game_runningv2: bool = true

#@onready var path_line: Line2D = $PathLine

const MOVEAUDIO := "uid://di2cxowmax22c"
const SUCCESSAUDIO := "uid://dknk3ftpg0qce"


func _ready() -> void:
	#Hacky way to choose one ig but oh well
	pairs.append(all_pairs.pick_random())
	
	
	var line_width := cell_size * 0.4
	for pair in pairs:
		var empty : Array[Vector2i] = []
		paths.append(empty)
		lines.append(_make_line(pair.color, line_width))
	
	overlay = Node2D.new()
	overlay.draw.connect(_draw_overlay)
	add_child(overlay)
	
	_build_obstacles(line_width)
	overlay.queue_redraw()
	#path_line.default_color = active_color
	#path_line.width = cell_size * 0.4
	#path_line.joint_mode = Line2D.LINE_JOINT_ROUND
	#path_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	#path_line.end_cap_mode = Line2D.LINE_CAP_ROUND

func _make_line(color: Color, width: float) -> Line2D:
	var line := Line2D.new()
	line.default_color = color
	line.width = width
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(line)
	return line

func _build_obstacles(line_width : float) -> void:
	if board_sprite == null or board_sprite.texture == null:
		push_warning("woah board_sprite isn't set - obstacles disabled")
		return
	var img := board_sprite.texture.get_image()
	if img.is_compressed():
		img.decompress()
	obstacles.build(img, _board_to_pixel, Vector2i(grid_width, grid_height),
	cell_size, line_width * 0.5 * clearance, dark_threshold)


func _board_to_pixel(p: Vector2) -> Vector2:
	var local := board_sprite.to_local(to_global(p))
	if board_sprite.centered:
		# bruh this took so long to realize
		local += board_sprite.texture.get_size() * 0.5
	return local - board_sprite.offset


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		
		_try_start_drawing(get_local_mouse_position())
		#if is_within_bounds(grid_pos):
			## TODO: only start if grid_pos has a starting dot
			#is_drawing = true
			#current_path = [grid_pos]
			#update_visual_line(get_local_mouse_position())

	elif event.is_action_released("Click"):
		_finish_drawing()
		#if is_drawing:
			#is_drawing = false
			#update_visual_line(Vector2.INF) # remove the tail
			## TODO: validate if path connects to target
			#print("Finished path: ", current_path)

	elif event is InputEventMouseMotion and active_index != -1:
		var mouse_pos = get_local_mouse_position()
		extend_path_toward(mouse_pos)
		update_visual_line(active_index, mouse_pos)

func _try_start_drawing(mouse_pos :Vector2) -> void:
	var cell = screen_to_grid(mouse_pos)
	if not is_within_bounds(cell):
		return
	for i in pairs.size():
		var path:Array[Vector2i] = paths[i]
		
		#check if click end of existing point, then resume
		if not path.is_empty() and path.back() == cell:
			active_index = i
			update_visual_line(i, mouse_pos)
			return
		
		if cell == pairs[i].start or cell == pairs[i].end:
			#actually allow drawing
			active_index = i
			var p: Array[Vector2i] = [cell]
			paths[i] = p
			update_visual_line(i, mouse_pos)
			return

func _finish_drawing() -> void:
	if active_index == -1:
		return
	var i := active_index
	active_index = -1
	update_visual_line(i, Vector2.INF) # remove tail
	if _all_complete() and game_runningv2:
		game_runningv2 = false
		AudioManager.play(SUCCESSAUDIO)
		Global.minigame_won()

func extend_path_toward(mouse_pos: Vector2) -> void:
	var path : Array[Vector2i] = paths[active_index]
	var target := _target_of(active_index)
	# Walk one cell at a time toward the mouse until we reach it or get blocked.
	# The counter is a safety net against infinite loops.
	for i in range(64):
		var last_cell: Vector2i = path.back()
		var offset = mouse_pos - grid_to_screen(last_cell)

		# Mouse is still inside the last cell: nothing to do
		if absf(offset.x) <= cell_size * 0.5 and absf(offset.y) <= cell_size * 0.5:
			return
		
		var moved := false
		
		for step in _candidate_steps(offset):
			if _apply_step(path, last_cell + step, target):
				moved = true
				AudioManager.play(MOVEAUDIO)
				break
		if not moved:
			return
		
		if path.back() == target:
			_finish_drawing()
			return
		
		## Step along whichever axis the mouse is farthest from (no diagonals)
		#var step := Vector2i.ZERO
		#if absf(offset.x) > absf(offset.y):
			#step.x = int(signf(offset.x))
		#else:
			#step.y = int(signf(offset.y))
		#var next_cell = last_cell + step
#
		#if not is_within_bounds(next_cell):
			#return  # mouse is outside the grid; stay at the edge
#
		## Going backwards: trim
		#if current_path.size() > 1 and next_cell == current_path[-2]:
			#current_path.pop_back()
			#continue
#
		## Ran into our own path: cut back to that cell (Flow Free behavior)
		#if current_path.has(next_cell):
			#while current_path.back() != next_cell:
				#current_path.pop_back()
			#continue
#
		## TODO: return here if next_cell is occupied by another color
		#current_path.append(next_cell)

func _candidate_steps(offset: Vector2) -> Array[Vector2i]:
	var half := cell_size * 0.5
	var sx := Vector2i(int(signf(offset.x)), 0)
	var sy := Vector2i(0, int(signf(offset.y)))
	var x_far := absf(offset.x) > half
	var y_far := absf(offset.y) > half
	var steps : Array[Vector2i] = []
	if absf(offset.x) > absf(offset.y):
		if x_far: steps.append(sx)
		if y_far: steps.append(sy)
	else:
		if y_far: steps.append(sy)
		if x_far: steps.append(sx)
	return steps

func _apply_step(path: Array[Vector2i], next_cell:Vector2i, target: Vector2i) -> bool:
	if not is_within_bounds(next_cell):
		return false
	if path.size() > 1 and next_cell == path[-2]:
		path.pop_back()
		return true
	if path.back() == target: # already connected to target
		return false
	if path.has(next_cell):
		while path.back() != next_cell: #rewind
			path.pop_back()
		return true
	if obstacles.is_step_blocked(path.back(), next_cell):
		return false
	if _cell_taken_by_other(next_cell):
		return false
	path.append(next_cell)
	return true

func _target_of(i: int) -> Vector2i:
	var p: Array[Vector2i] = paths[i]
	return pairs[i].end if p[0] == pairs[i].start else pairs[i].start # can connect to either end or start

func _cell_taken_by_other(cell : Vector2i) -> bool:
	for i in pairs.size():
		if i == active_index:
			continue
		if cell == pairs[i].start or cell == pairs[i].end or (paths[i] as Array).has(cell):
			return true
	return false

func _is_complete(i: int) -> bool:
	var p: Array[Vector2i] = paths[i]
	return p.size() > 1 and p.back() == _target_of(i)

func _all_complete() -> bool:
	for i in pairs.size():
		if not _is_complete(i):
			return false
	return true

func screen_to_grid(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x / cell_size), floori(pos.y / cell_size))

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	return (Vector2(grid_pos) + Vector2(0.5, 0.5)) * cell_size

func is_within_bounds(grid_pos: Vector2i) -> bool:
	return grid_pos.x >= 0 and grid_pos.x < grid_width \
		and grid_pos.y >= 0 and grid_pos.y < grid_height

func update_visual_line(i: int, mouse_pos: Vector2) -> void:
	var line := lines[i]
	var path:Array[Vector2i] = paths[i]
	line.clear_points()
	#path_line.clear_points()
	for cell in path:
		line.add_point(grid_to_screen(cell))
	# Small "tail" that leans toward the mouse, so the line feels attached to the cursor
	if i == active_index and mouse_pos != Vector2.INF and not path.is_empty() \
			and path.back() != _target_of(i):
		var last_center := grid_to_screen(path.back())
		line.add_point(last_center +(mouse_pos - last_center).limit_length(cell_size*0.5))  
	#if is_drawing and mouse_pos != Vector2.INF:
		#var last_center = grid_to_screen(current_path.back())
		#var tail = (mouse_pos - last_center).limit_length(cell_size * 0.5)
		#path_line.add_point(last_center + tail)

func _draw_overlay() -> void:
	for pair in pairs:
		for cell in [pair.start, pair.end]:
			overlay.draw_circle(grid_to_screen(cell), cell_size * 0.3, pair.color)
	if debug_draw:
		for key in obstacles.blocked_edges:
			overlay.draw_line(grid_to_screen(Vector2i(key.x, key.y)),
					grid_to_screen(Vector2i(key.z, key.w)), Color(1,1,0,0.6), 4.0)
		for cell in obstacles.blocked_cells:
			overlay.draw_circle(grid_to_screen(cell), 6.0, Color.YELLOW)
