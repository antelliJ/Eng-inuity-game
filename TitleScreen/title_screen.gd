extends Node2D
@onready var background: TextureRect = $Background
@onready var bot_2: Sprite2D = $Bot2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transition.playTransitionIn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#background.material.set("shader_parameter/bg",)
	var time_elapsed : float = Time.get_ticks_msec()
	var color_s :float = (time_elapsed/5000) - floor((time_elapsed/1000))
	var color : Color = Color.from_hsv(color_s,0.2, 1.0);
	background.material.set_shader_parameter("bg", color)
	
	var bot_scale :float =  (sin(time_elapsed/500) * .2)+0.3
	bot_2.scale = Vector2(bot_scale,bot_scale)

func _on_start_btn_pressed() -> void:
	#Transition.playTransition("res://Minigames/ClipParts/ClipParts.tscn") # assume everything loads instantly
	#get_tree().change_scene_to_file("res://level_scene.tscn")
	
	Global.shuffle_minigames()
	Global.next_minigame()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_settings_btn_pressed() -> void:
	Global.toggle_settings.emit()
