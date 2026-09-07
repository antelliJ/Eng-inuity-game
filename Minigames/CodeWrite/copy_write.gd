extends Node2D

@onready var keyboardDude: copyKeyboard = $CodeWriting
@onready var coding_level_bar: TextureProgressBar = $CodingLevelBar
@onready var color_rect: ColorRect = $CodingLevelBar/ColorRect

@export var monitorTextArrays:Array[Sprite2D]
@export var dangerColors:Gradient

@onready var timer_scene: TimerThing = $TimerScene

var maxCodeLevel:float = 100
var codeLevel:float = 75

var visualCodeLevel:float = 75

var reducingRate:float = 25
var tweenAlive : bool = false

var game_running :bool = true
var timer_end : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keyboardDude.successfulCopy.connect(copiedCode)
	
	await timer_scene.Timer(5.0)
	timer_end = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#visualCodeLevel = 
	#coding_level_bar.value = visualCodeLevel
	codeLevel -= reducingRate*delta
	if !tweenAlive:
		visualCodeLevel = max(codeLevel, 0)
	
	var codingLvlPercent :float = (visualCodeLevel/maxCodeLevel)
	coding_level_bar.value = visualCodeLevel
	color_rect.scale.y = codingLvlPercent
	color_rect.color = dangerColors.sample(1-codingLvlPercent)
	#print(reducingRate*delta)
	
	if (codeLevel < 0) and game_running:
		print("game lost")
		game_running = false
		Global.minigames_done -= 1 # stay on this minigame
		Global.lives -= 1
		Global.minigame_lost()
	
	var time_elapsed : float = Time.get_ticks_msec()
	var funny_x_scale:float = (sin(time_elapsed/500) * .4)+1
	funny_x_scale = lerp(keyboardDude.get_x_scale(), funny_x_scale, delta*50)
	keyboardDude.expand_board(funny_x_scale)
	
	if game_running and timer_end:
		game_running = false
		Global.minigame_won()

func copiedCode()->void:
	codeLevel = clamp(codeLevel+15, 0, maxCodeLevel)
	#create_tween().tween_property(coding_level_bar,"value",codeLevel,0.3).set_trans(Tween.TRANS_ELASTIC)
	show_new_code_img()
	var tween := create_tween().tween_property(self,"visualCodeLevel",codeLevel,0.3).set_trans(Tween.TRANS_BOUNCE)
	tweenAlive = true
	await tween.finished
	tweenAlive = false

func show_new_code_img()->void:
	for codeImg in monitorTextArrays:
		codeImg.hide()
	var selected : Sprite2D = monitorTextArrays.pick_random()
	selected.show()
	
	var randHue = randf_range(0.0, 5.0)
	selected.material.set_shader_parameter("Shift_Hue", randHue)
