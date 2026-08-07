extends Node2D

@onready var clip_1: Area2D = $Clip1

var mouse_in_clip1: bool = false
var move_clip1: bool = false


@onready var path_1: Path2D = $Path1
@onready var line_1: Line2D = $Path1/Line1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_line_from_curve(path_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if move_clip1:
		clip_1.position = get_local_mouse_position()
		path_1.curve.set_point_position(path_1.curve.point_count-1, clip_1.position)
		draw_line_from_curve(path_1)

func draw_line_from_curve(path : Path2D) -> void:
	var curve :Curve2D = path.curve
	var points :PackedVector2Array = curve.get_baked_points()
	line_1.points = points

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

func _on_clip_1_mouse_entered() -> void:
	mouse_in_clip1 = true


func _on_clip_1_mouse_exited() -> void:
	mouse_in_clip1 = false
