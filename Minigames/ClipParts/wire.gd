extends Node2D
class_name clip_wire

@export var wire_color: Color = Color('000000')

@onready var clip_1: Area2D = $Clip1

var mouse_in_clip1: bool = false
var move_clip1: bool = false

@onready var path_1: Path2D = $Path1
@onready var line_1: Line2D = $Path1/Line1

@onready var cover_sprite: Sprite2D = $Clip1/coverSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_1.curve = path_1.curve.duplicate(true)
	draw_line_from_curve(path_1, line_1)
	
	clip_1.mouse_entered.connect(_on_clip_1_mouse_entered)
	clip_1.mouse_exited.connect(_on_clip_1_mouse_exited)
	
	setup_colors()

func setup_colors()->void:
	line_1.default_color = wire_color
	cover_sprite.self_modulate = wire_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_clip1:
		var mousepos := get_local_mouse_position()
		#var dir := (mousepos - clip_1.position).normalized()
		#var rot := dir.angle()
		#clip_1.look_at(mousepos)
		clip_1.position = mousepos
		path_1.curve.set_point_position(path_1.curve.point_count-1, clip_1.position)
		
		var point_before_pos: Vector2 = path_1.curve.get_point_position(path_1.curve.point_count-2)
		var new_before_pos: Vector2 = point_before_pos.lerp(mousepos, 0.1) # Change 0.1 to adjust pull strength
		path_1.curve.set_point_position(path_1.curve.point_count-2, new_before_pos)
		
		draw_line_from_curve(path_1, line_1)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		# move logic here?
		if mouse_in_clip1:
			move_clip1 = true
			clip_1.find_child("Sprite2D").frame = 1
	if event.is_action_released("Click"):
		if mouse_in_clip1:
			move_clip1 = false
			clip_1.find_child("Sprite2D").frame = 0

func draw_line_from_curve(path : Path2D, line: Line2D) -> void:
	var curve :Curve2D = path.curve
	var points :PackedVector2Array = curve.get_baked_points()
	line.points = points
	
func _on_clip_1_mouse_entered() -> void:
	mouse_in_clip1 = true


func _on_clip_1_mouse_exited() -> void:
	mouse_in_clip1 = false

func get_clip_area2d() -> Area2D:
	return $Clip1
