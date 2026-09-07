extends Node2D
class_name minigame
@onready var instruction_header_label: Label = $Control/InstructionHeaderLabel
@onready var image_instruction_images_container: HBoxContainer = $Control/ImageInstructionImagesContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var timer: Timer = $Control/Timer

#ALL MINIGAMES SHOULD EXTEND AND SUPER() THE METHODS

@export var gameName:String = "Sample Game title"
@export var gameHeadline:String = "Connect the wires or smth!"
@export var instructionImages:Array[Texture2D]
@export var instructionReadTime : float = 4.0
#@export var game_running:bool = false

func _ready() -> void:
	# pause scene for like 0.2 secs?
	$Control.show()
	$Control.position = (Vector2.ZERO)
	print("Minigame position ",$Control.position)
	get_tree().paused = true
	instruction_header_label.text = gameHeadline
	for image in instructionImages:
		var texture_rect = TextureRect.new()
		texture_rect.texture = image
		#texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		image_instruction_images_container.add_child(texture_rect)
		#image_instruction_images_container.add_spacer()
	
	#await get_tree().create_timer(instructionReadTime).timeout
	timer.wait_time = instructionReadTime
	timer.start()
	



func headline_animation_ended()->void:
	$Control.hide()
	$Control.position = (Vector2.ZERO)
	await get_tree().create_timer(0.05).timeout
	get_tree().paused = false


func _on_timer_timeout() -> void:
	animation_player.play("scroll_up")
