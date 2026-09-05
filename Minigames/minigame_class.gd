extends Node2D
class_name minigame

#ALL MINIGAMES SHOULD EXTEND AND SUPER() THE METHODS

var gameName:String = "Sample Game title"

func _ready() -> void:
	# pause scene for like 0.2 secs?
	pass

func _physics_process(delta: float) -> void:
	pass
