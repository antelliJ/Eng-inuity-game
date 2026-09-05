extends Control
@onready var winnerNode: Control = $Winner
@onready var loserNode: Control = $DeathSad

@onready var spooky_timer: Timer = $SpookyTimer
@onready var spooky_sprite: TextureRect = $DeathSad/DissapointedFailure
@export var spookyLevel : Curve


@onready var bot_2: Sprite2D = $Winner/Bot2
@onready var bg_color: ColorRect = $"BG-Color2"
@onready var bg_shader: TextureRect = $Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_winner():
		winnerNode.show()
		loserNode.hide()
		var color : Color = Color("004e1e")
		#background.material.set_shader_parameter("bg", color)
		bg_color.color = color
		
	else:
		loserNode.show()
		winnerNode.hide()
		spooky_timer.start()
		var color : Color = Color("001f08")
		#background.material.set_shader_parameter("bg", color)
		bg_color.color = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spooky_timer.time_left > 0:
		handle_spook()
	var time_elapsed : float = Time.get_ticks_msec()
	var bot_scale :float =  (sin(time_elapsed/500) * .2)+0.3
	bot_2.scale = Vector2(bot_scale,bot_scale)

func handle_spook() -> void:
	var spook_lvl: float = spookyLevel.sample(remap(spooky_timer.time_left, 10, 0, 0, 1))
	print("its off the charts! ", spook_lvl)
	var scale: float = remap(spook_lvl, 0, 1, 0.25, 0.95)
	spooky_sprite.scale = Vector2(scale, scale)
	#var alpha:float =remap(spook_lvl, 0, 1, 0, 255)
	spooky_sprite.modulate.a = spook_lvl # it goes from 0-1

func is_winner() -> bool:
	return Global.GameWon == Global.GameWinStates.WON




func _on_return_btn_pressed() -> void:
	Global.reset_game()
	Transition.playTransition("res://TitleScreen/title_screen.tscn")
