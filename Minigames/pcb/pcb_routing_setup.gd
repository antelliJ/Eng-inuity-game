extends Node2D

@onready var timer_scene: TimerThing = $TimerScene
var timer_end :bool = false
var game_running : bool = true # ensure only send cmd once
@onready var game_board: Node2D = $GameBoard

@export var playtime: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await timer_scene.Timer(playtime)
	timer_end = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_end and game_running and game_board.game_runningv2: #Game over :O
		game_running = false
		#Global.minigames_done -= 1 # stay on this minigame
		#Global.lives -= 1
		# TODO TEMP
		#Transition.playTransition("res://TitleScreen/game_over.tscn")
		Global.minigame_lost()
