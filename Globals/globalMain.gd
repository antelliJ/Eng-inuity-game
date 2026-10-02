extends Node

#var mainState : Dictionary = {
	#"score":	0
#}
const TOTAL_LIVES : int = 3
var lives : int = TOTAL_LIVES
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

@export var livesDisplayScene : PackedScene

var changing_minigame_scene : bool = false

@export var max_speed_mult := 3.0
@export var speedmult_ramp := 0.3
var game_speed_mult : float = 1.5

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
	lives = TOTAL_LIVES
	score = 0
	minigames_done = 0
	minigameIndex = 0
	GameState = GameStates.MENU
	GameWon = GameWinStates.UNKNOWN
	game_speed_mult = 1.0

func continue_game() -> void:
	minigameIndex = 0
	GameWon = Global.GameWinStates.UNKNOWN
	#Global.game_speed_mult += .5
	
	game_speed_mult = lerpf(game_speed_mult, max_speed_mult, speedmult_ramp)
	
	shuffle_minigames()
	start_minigames()

func shuffle_minigames() -> void:
	if !do_minigame_shuffle:
		return
	MinigamesList.minigames.shuffle()
	#pass

func minigame_won() -> void:
	if !changing_minigame_scene:
		next_minigame()
		GameWon = GameWinStates.WON
		minigames_done += 1
func minigame_lost() -> void:
	if !changing_minigame_scene:
		GameWon = GameWinStates.LOST
		lives -= 1
		print("GLOBAL: CURRENT LIVES ", lives)
		Transition.playTransition(livesDisplayScene.resource_path)
	#next_minigame()

func start_minigames() -> void:
	changing_minigame_scene = false
	var minigame_scene_file : String = MinigamesList.minigames[minigameIndex].resource_path
	Transition.playTransition(minigame_scene_file)
	GameWon = GameWinStates.UNKNOWN

func next_minigame() -> void:
	# should play some infomatic / animation about the upcoming level?
	print("GLOBAL: MINIGAME INDEX ", minigameIndex)
	changing_minigame_scene = false
	if (minigameIndex < MinigamesList.minigames.size()) and (GameWon != GameWinStates.LOST):
		# open next minigame
		print("GLOBAL: OPENING NEXT MINIGAME (+1 from previous val)")
		minigameIndex += 1
		if (minigameIndex >= MinigamesList.minigames.size()):
			Transition.playTransition("res://TitleScreen/game_over.tscn")
			return
		var minigame_scene_file : String = MinigamesList.minigames[minigameIndex].resource_path
		Transition.playTransition(minigame_scene_file)
		GameWon = GameWinStates.UNKNOWN
		
	else:
		#TODO do a check if lives is 0 or something
		# I don't think the minigame branch is accessible here,
		# only on the above if branch 
		if lives <= 0 or (minigameIndex >= MinigamesList.minigames.size()):
			#Go to end screen
			Transition.playTransition("res://TitleScreen/game_over.tscn")
		else:
			print("GLOBAL: REPLAY MINIGAME")
			# replay the minigame
			var minigame_scene_file : String = MinigamesList.minigames[minigameIndex].resource_path
			Transition.playTransition(minigame_scene_file)
			GameWon = GameWinStates.UNKNOWN
			


func _on_continue_btn_pressed() -> void:
	gamePaused = false
	#pause_menu.visible = gamePaused
	get_tree().paused = gamePaused 
