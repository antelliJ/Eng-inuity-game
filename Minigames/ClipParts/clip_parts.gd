#extends minigame
extends Node2D

@export var connections : Array[connect_wire]

@onready var timer_scene: TimerThing = $TimerScene
var timer_end :bool = false
var game_running : bool = true
const WIRECONNECTSOUND := "uid://bv1epvmwo3p8s"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#super()
	randomize_clips_wires()
	
	
	for wire in connections:
		wire.wire_connected.connect(_on_wire_connected)
		draw_line_from_curve(wire.get_path_node(), wire.get_line_node())
		
		
	await timer_scene.Timer(5.0)
	timer_end = true

func randomize_clips_wires()->void:
	var og_connections : Array[connect_wire] = connections
	var og_wires : Array[clip_wire] = []
	for wire_child in $WIRES.get_children():
		if wire_child is clip_wire:
			og_wires.append(wire_child)
	
	og_connections.shuffle()
	print("OG CONNECTIONS ", og_connections)
	og_wires.shuffle()
	print("OG WIRES ", og_wires)
	for i in range(og_wires.size()):
		og_wires[i].wire_color = og_connections[i].my_color
		og_connections[i].desired_col = og_wires[i].get_clip_area2d()
		
		og_wires[i].setup_colors()
		og_connections[i].setup_colors()
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	if timer_end and game_running: #Game over :O
		game_running = false
		#Global.minigames_done -= 1 # stay on this minigame
		#Global.lives -= 1
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
	AudioManager.play(WIRECONNECTSOUND)
	for wire in connections:
		if (!wire.connect_success):
			can_continue = false
	if can_continue and game_running:
		print("YOU DID IT! you win", can_continue)
		game_running = false
		#TODO IS TEMP
		#Transition.playTransition("res://TitleScreen/game_over.tscn")
		Global.minigame_won()
	
#func end_round()->void:
	## called when connect all, or time out
	#pass
