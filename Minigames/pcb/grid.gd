extends Node2D

@export var cell_size: Vector2 = Vector2(64, 64)
@export var grid_color: Color = Color(1, 1, 1, 0.3)

@export var grid_width : int = 5
@export var grid_height : int = 5

func _draw() -> void:
	var rect = get_viewport_rect()
	
	# Draw vertical lines
	var x = 0.0
	while (x <= rect.size.x) and (x <= cell_size.x*grid_width):
		draw_line(Vector2(x, 0), Vector2(x, cell_size.y*grid_height), grid_color)
		x += cell_size.x
		
	# Draw horizontal lines
	var y = 0.0
	while (y <= rect.size.y) and (y <= cell_size.y*grid_height):
		draw_line(Vector2(0, y), Vector2(cell_size.x*grid_width, y), grid_color)
		y += cell_size.y
