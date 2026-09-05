extends RigidBody2D

@export var player:CharacterBody2D
@export var modulateRamp:Gradient

@onready var attack_timer: Timer = $AttackTimer
@onready var sprite: Sprite2D = $Sprite2D

var attackWaitTime:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("bug ready called")
	attackWaitTime = attack_timer.wait_time
	await get_tree().create_timer(0.5, true).timeout
	attack_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.look_at(player.position)
	sprite.rotation_degrees += 90
	
	var attack_progression: float = (attack_timer.time_left / attackWaitTime)
	sprite.self_modulate = modulateRamp.sample(attack_progression)


func _on_timer_timeout() -> void:
	#ATTACK
	Attack()
	
	attack_timer.start()
	
func Attack() -> void:
	#apply_impulse()
	var push_direction : Vector2 = (player.global_position - global_position).normalized()
	apply_central_impulse(push_direction*1000.0)
	
	
