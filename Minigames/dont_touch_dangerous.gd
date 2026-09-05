extends minigame

@onready var player_tongue_finger: CharacterBody2D = $PlayerTongueFinger


@onready var timer_scene: TimerThing = $TimerScene
var timer_end :bool = false
var game_ended : bool = false # ensure only send cmd once

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	get_tree().paused = true
	await get_tree().create_timer(0.2, true).timeout
	get_tree().paused = false
	
	
	await timer_scene.Timer(10.0)
	timer_end = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_end: #you survived! :O
		Global.minigames_done -= 1 # stay on this minigame
		Global.lives -= 1
		# TODO TEMP
		#Transition.playTransition("res://TitleScreen/game_over.tscn")
		if !game_ended:
			Global.next_minigame()
			game_ended = true


func _on_bug_body_entered(body: Node) -> void:
	if nodeIsPlayer(body):
		print("BUG HIT PLAYER")
		game_lost()

func game_lost()->void:
	if !game_ended:
		Global.minigame_lost()
		game_ended = true

func nodeIsPlayer(body: Node) -> bool:
	if body.has_method("isPlayer"):
		return true
	return false

func _on_battery_body_entered(body: Node2D) -> void:
	if nodeIsPlayer(body):
		print("TOASTER HITS PLAYER")
		game_lost()
