extends Control
@onready var instruction_header_label: Label = $InstructionHeaderLabel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var time_elapsed : float = Time.get_ticks_msec()
	var label_scale :float =  (sin(time_elapsed/200) * .3)+1
	
	instruction_header_label.scale = Vector2(label_scale,label_scale)
	var instruct_time: float = $"..".instructionReadTime
	progress_bar.value = ((instruct_time - timer.time_left) / instruct_time) * 100
