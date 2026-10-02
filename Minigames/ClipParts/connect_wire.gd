extends Node2D
class_name connect_wire

@export var my_col : Area2D

@export var desired_col: Area2D

@export var my_color : Color

@onready var particles: CPUParticles2D = $Particles


var connect_success :bool = false
signal wire_connected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_colors()
	
func setup_colors()->void:
	$Path2D/Line2D.default_color = my_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var is_inside : bool =check_if_inside()
	particles.emitting = !is_inside
	#print(is_inside)
	if (!connect_success and is_inside):
		connect_success = true
		wire_connected.emit()
		print("Wire connected!")
	elif (connect_success and !is_inside):
		connect_success = false
	
func _input(event: InputEvent) -> void:
	pass
	#if event.is_action_released("Click"):
		# do check if its inside
		#var is_inside : bool =check_if_inside()
		#particles.emitting = !is_inside
		##print(is_inside)
		#if (!connect_success and is_inside):
			#connect_success = true
			#wire_connected.emit()
			#print("Wire connected!")
		#elif (connect_success and !is_inside):
			#connect_success = false
		
			
func get_path_node() -> Path2D:
	return $Path2D

func get_line_node() -> Line2D:
	return $Path2D/Line2D

func check_if_inside()->bool:
	return my_col.overlaps_area(desired_col)
