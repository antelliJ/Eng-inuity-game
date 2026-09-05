extends minigame

@export var connections : Array[connect_wire]

@onready var timer_scene: TimerThing = $TimerScene
var timer_end :bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	
	for wire in connections:
		wire.wire_connected.connect(_on_wire_connected)
		draw_line_from_curve(wire.get_path_node(), wire.get_line_node())
		
		
	await timer_scene.Timer(5.0)
	timer_end = true




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	if timer_end: #Game over :O
		Global.minigames_done -= 1 # stay on this minigame
		Global.lives -= 1
		# TODO TEMP
		#Transition.playTransition("res://TitleScreen/game_over.tscn")
		Global.minigame_lost()

func draw_line_from_curve(path : Path2D, line: Line2D) -> void:
	var curve :Curve2D = path.curve
	var points :PackedVector2Array = curve.get_baked_points()
	line.points = points



func _on_wire_connected() -> void:
	#check if every cable is connected, if so can end round
	var can_continue : bool = true
	for wire in connections:
		if (!wire.connect_success):
			can_continue = false
	if can_continue:
		print("YOU DID IT! you win", can_continue)
		#TODO IS TEMP
		#Transition.playTransition("res://TitleScreen/game_over.tscn")
		Global.minigame_won()
	
#func end_round()->void:
	## called when connect all, or time out
	#pass
