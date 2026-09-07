extends Node2D
class_name copyKeyboard

signal successfulCopy

var paste_ready : bool = false
var x_scale :float = 1.0
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
const DEFAULT_PATCH_SIZE := Vector2(1056.0, 646.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nine_patch_rect.grow_horizontal = Control.GROW_DIRECTION_BOTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_copy_btn_pressed() -> void:
	paste_ready = true



func _on_paste_btn_pressed() -> void:
	#print("paste btn pressed")
	if paste_ready:
		paste_ready = false
		successfulCopy.emit()

func get_x_scale() -> float:
	#return nine_patch_rect.size.x
	return x_scale
	
func expand_board(x_scale_new: float, y_scale:float = 1.0):
	x_scale = x_scale_new
	
	nine_patch_rect.size = DEFAULT_PATCH_SIZE *  Vector2(x_scale, y_scale)
