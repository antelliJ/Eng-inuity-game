class_name ObstacleMap
extends RefCounted

var blocked_cells : Dictionary = {} # vector 2i
var blocked_edges : Dictionary = {} #Vector 4i, cell pair

var _image : Image
var _to_pixel : Callable # board-local vector 2 to texture pixel vector 2
var _threshold : float
var _spacing : float

func build(image : Image, to_pixel: Callable, grid_size : Vector2i,
			cell_size: float, brush_radius: float, threshold:float) -> void:
	_image = image
	_to_pixel = to_pixel
	_threshold = threshold
	_spacing = maxf(1.0, cell_size / 32.0)
	blocked_cells.clear()
	blocked_edges.clear()
	
	for y in grid_size.y:
		for x in grid_size.x:
			var cell := Vector2i(x,y)
			if _disc_hits(_center(cell, cell_size), brush_radius):
				blocked_cells[cell] = true
			if x+1 < grid_size.x:
				_test_edge(cell, cell + Vector2i.RIGHT, cell_size, brush_radius)
			if y+1 < grid_size.y:
				_test_edge(cell, cell + Vector2i.DOWN, cell_size, brush_radius)
				
func is_step_blocked(from: Vector2i, to: Vector2i) -> bool:
	return blocked_cells.has(to) or blocked_edges.has(_edge_key(from, to))

func _center(cell: Vector2i, cell_size: float) -> Vector2:
	return (Vector2(cell) + Vector2(0.5,0.5)) * cell_size

# sweep brush along center-to-center segment, blocking edge is sampled
# pixel is dark
func _test_edge(a: Vector2i, b: Vector2i, cell_size: float, r: float) -> void:
	var pa := _center(a, cell_size)
	var pb := _center(b, cell_size)
	var perp := (pb - pa).normalized().orthogonal() # normal
	var steps := maxi(1, int(ceil(pa.distance_to(pb) / _spacing)))
	var sweep := int(r/_spacing)
	for i in range(steps + 1):
		var p := pa.lerp(pb, float(i)/steps)
		for k in range(-sweep, sweep +1):
			if _is_dark(p + perp * (k * _spacing)):
				blocked_edges[_edge_key(a, b)] = true
				return

func _disc_hits(center: Vector2, r: float) -> bool:
	var n := int(r / _spacing)
	for ky in range(-n, n+1):
		for kx in range(-n, n+1):
			var off := Vector2(kx,ky) * _spacing
			if off.length() <= r and _is_dark(center + off):
				return true
	return false

func _is_dark(board_pos: Vector2) -> bool:
	var px: Vector2 = _to_pixel.call(board_pos)
	var x := floori(px.x)
	var y := floori(px.y)
	if x < 0 or y < 0 or x >= _image.get_width() or y >= _image.get_height():
		return false
	var c := _image.get_pixel(x, y)
	return c.a > 0.5 and c.get_luminance() < _threshold

static func _edge_key(a: Vector2i, b: Vector2i) -> Vector4i:
	if a.x > b.x or (a.x == b.x and a.y > b.y):
		var t := a
		a = b
		b = t
	return Vector4i(a.x, a.y, b.x, b.y)
