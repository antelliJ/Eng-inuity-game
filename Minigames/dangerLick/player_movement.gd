extends CharacterBody2D


const SPEED : float = 300.0
@onready var game_head: Node2D = $".."

var damage_taken : bool = false

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_x := Input.get_axis("ui_left", "ui_right")
	var dir_y := Input.get_axis("ui_up", "ui_down")
	
	#print(get_angle_to(get_local_mouse_position()))
	look_at($"..".get_local_mouse_position())
	rotation_degrees += 90
	#rotation = rotate_toward(rotation, get_angle_to(game_head.get_local_mouse_position()), delta*5)
	
	
	
	if dir_x or dir_y:
		velocity.x = dir_x * SPEED
		velocity.y = dir_y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func isPlayer()->bool:
	return true
