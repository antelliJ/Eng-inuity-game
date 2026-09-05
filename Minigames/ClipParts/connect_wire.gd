extends Node2D
class_name connect_wire

@export var my_col : Area2D

@export var desired_col: Area2D


@onready var particles: GPUParticles2D = $Particles


var connect_success :bool = false
signal wire_connected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("Click"):
		# do check if its inside
		var is_inside : bool =check_if_inside()
		particles.emitting = !is_inside
		#print(is_inside)
		if (!connect_success and is_inside):
			connect_success = true
			wire_connected.emit()
			print("Wire connected!")
		elif (connect_success and !is_inside):
			connect_success = false
		
			
func get_path_node() -> Path2D:
	return $Path2D

func get_line_node() -> Line2D:
	return $Path2D/Line2D

func check_if_inside()->bool:
	return my_col.overlaps_area(desired_col)
