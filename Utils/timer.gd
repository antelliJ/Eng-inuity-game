extends Node2D
class_name TimerThing
@onready var timer: RichTextLabel = $timer
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

var time : float
var total_time: float

# maybe add some coloration / modulation depending on how much time is left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer.text = '  ' + str(snapped(time, 0.10))
	texture_progress_bar.value = (snapped(time, 0.10) / total_time) * 100

func Timer(start_time :float):
	# when it reaches 0 it should transition to the next scene
	total_time = start_time
	time = start_time
	
	while time > 0.00:
		await wait(0.10)
		time -= 0.10
		
	# when the timer reaches 0
	return

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
