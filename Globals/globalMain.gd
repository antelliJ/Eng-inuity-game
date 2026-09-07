extends Node

#var mainState : Dictionary = {
	#"score":	0
#}
var lives : int = 5
var score : int = 0

var minigames_done : int = 0
var do_minigame_shuffle : bool = true

enum GameStates {MENU, PLAYING, STATS}
enum GameWinStates {UNKNOWN, WON, LOST}
signal toggle_settings

# Called when the node enters the scene tree for the first time.
@export var settings_scene : PackedScene
var settings_open : bool = false
var setting_node : Node

@export var MinigamesList : minigameHolder
var minigameIndex : int = 0
var currentMinigame : minigame

var GameState : GameStates = GameStates.MENU
var GameWon : GameWinStates = GameWinStates.UNKNOWN

var gamePaused : bool = false
#@onready var pause_menu: Control = $PauseMenu
signal pauseGameSignal(open:bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_settings.connect(toggle_settings_view)
	pauseGameSignal.connect(toggle_pause)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause(!gamePaused)
	
func toggle_pause(toOpen:bool)->void:
	gamePaused = !gamePaused
	#pause_menu.visible = gamePaused
	get_tree().paused = gamePaused
	#if gamePaused:
		#pauseGameSignal.emit(true)

func toggle_settings_view() -> void:
	if !settings_open:
		setting_node = settings_scene.instantiate()
		settings_open = true
		setting_node.show()
		#add_child(setting_node)
		get_tree().root.add_child(setting_node)
		return
	#otherwise
	if is_instance_valid(setting_node):
		setting_node.queue_free()
		settings_open = false

func reset_game() -> void:
	lives = 5
	score = 0
	minigames_done = 0
	minigameIndex = 0
	GameState = GameStates.MENU
	GameWon = GameWinStates.UNKNOWN

func shuffle_minigames() -> void:
	if !do_minigame_shuffle:
		return
	MinigamesList.minigames.shuffle()
	#pass

func minigame_won() -> void:
	next_minigame()
	GameWon = GameWinStates.WON
func minigame_lost() -> void:
	GameWon = GameWinStates.LOST
	next_minigame()

func next_minigame() -> void:
	# should play some infomatic / animation about the upcoming level?
	print("MINIGAME INDEX ", minigameIndex)
	if (minigameIndex < MinigamesList.minigames.size()) and (GameWon != GameWinStates.LOST):
		# open next minigame
		var minigame_scene_file : String = MinigamesList.minigames[minigameIndex].resource_path
		Transition.playTransition(minigame_scene_file)
		minigameIndex += 1
		GameWon = GameWinStates.UNKNOWN
		
	else:
		#TODO do a check if lives is 0 or something
		#Go to end screen
		Transition.playTransition("res://TitleScreen/game_over.tscn")


func _on_continue_btn_pressed() -> void:
	gamePaused = false
	#pause_menu.visible = gamePaused
	get_tree().paused = gamePaused 
