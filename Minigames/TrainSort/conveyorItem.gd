class_name ConveyorItem
extends Sprite2D

@export var bossNode : aiSorting

var currentPath : Path2D
var pathProgress : float = 0.0
var totalPath:float = 0.0
var progressRate : float = 200.0
var progressRateMult : float = 1.0

@onready var area_2d: Area2D = $Area2D

signal completedPath(path : Path2D, spritePath : String)

# set to true when going on the final production line
var chosen_path : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setPath(currentPath)
	area_2d.area_entered.connect(_on_area_2d_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progressRateMult = Global.game_speed_mult
	pathProgress += progressRate*delta * progressRateMult
	# reached the end of the line
	if pathProgress >= totalPath and chosen_path:
		#TODO the checks if its the correct one
		completedPath.emit(currentPath, texture.resource_path)
		queue_free()
	followPath(currentPath, wrapf(pathProgress, 0, totalPath))

func setPath(path:Path2D)->void:
	if !can_process():
		return
	currentPath = path
	pathProgress = 0
	totalPath = currentPath.curve.get_baked_length()

func followPath(path : Path2D, progress:float = 0.0)->void:
	
	var offset := path.curve.sample_baked(progress)
	global_position = path.global_position + offset
	#print(global_position)


func _on_area_2d_area_entered(area: Area2D) -> void:
	#currentPath = bossNode.get_path_from_dir()
	setPath(bossNode.get_path_from_dir())
	chosen_path = true
	progressRate += 600
	
