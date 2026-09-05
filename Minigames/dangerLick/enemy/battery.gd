extends Area2D

@export var player: CharacterBody2D

const SPEED : float = 150

var target: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target = player.position
	position.x = move_toward(position.x, target.x, delta*SPEED)
	position.y = move_toward(position.y, target.y, delta*SPEED)
