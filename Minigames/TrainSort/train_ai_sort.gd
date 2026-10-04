class_name aiSorting
extends Node2D

@export var spawnableObjects : Array[ConveyorItem]
@export var spawningPoint:Node2D
@onready var pointer_box: Sprite2D = $PointerBox

@onready var bot_eye_l: Node2D = $BOT/LEyeHolder
@onready var bot_eye_r: Node2D = $BOT/REyeHolder

@onready var spawn_timer: Timer = $ItemSpawner/SpawnTimer
@onready var item_spawner: Node2D = $ItemSpawner

# dict with path2D key: array[where the icon is located, resource path]
@onready var OutputToPath: Dictionary = {
	"UP": [$Output1/MsgBox, ""] ,
	"RIGHT": [$Output2/MsgBox2, ""],
	"DOWN": [$Output3/MsgBox3, ""]
}

@export var playtime: float = 8.0
@onready var timer_scene: TimerThing = $TimerScene
var timer_end :bool = false
var game_running : bool = true

var point_dir :Vector2 = Vector2.UP

const SUCCESSAUDIO = "uid://c7diijk8polyj"
const DEATHAUDIO = "uid://shkljevojbev"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()
	
	spawnableObjects.shuffle()
	for i in range(OutputToPath.size()):
		var chosenObj := spawnableObjects[i].texture
		var icon := Sprite2D.new()
		icon.texture =chosenObj
		icon.scale = Vector2(0.3,0.3)
		
		var path : String = OutputToPath.keys()[i]
		
		OutputToPath[path][1] = chosenObj.resource_path
		OutputToPath[path][0].add_child(icon)
	
	await timer_scene.Timer(playtime)
	timer_end = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if timer_end and game_running:
		game_running = false
		Global.minigame_won()
	
	if item_spawner.get_child_count() > 1:
		var firstInLine : Node2D = item_spawner.get_child(1) as Node2D
		update_bot_lookat(firstInLine.global_position)


func _input(event: InputEvent) -> void:
	var moved: bool = false
	if event.is_action_pressed("up"):
		point_dir = Vector2.UP
		moved = true
	elif event.is_action_pressed("right"):
		point_dir = Vector2.RIGHT
		moved = true
	elif event.is_action_pressed("down"):
		point_dir = Vector2.DOWN
		moved = true
	
	if moved:
		update_pointer_sprite()

func update_pointer_sprite()->void:
	match point_dir:
		Vector2.UP:
			pointer_box.rotation_degrees = 0
		Vector2.RIGHT:
			pointer_box.rotation_degrees = 90
		Vector2.DOWN:
			pointer_box.rotation_degrees = 180

func update_bot_lookat(lookat : Vector2)->void:
	bot_eye_l.look_at(lookat)
	bot_eye_r.look_at(lookat)

func get_path_from_dir()->Path2D:
	match point_dir:
		Vector2.UP:
			return $StartingPath/UP
		Vector2.RIGHT:
			return $StartingPath/RIGHT
		Vector2.DOWN:
			return $StartingPath/DOWN
	return %StartingPath


func _on_spawn_timer_timeout() -> void:
	spawn_obj()
	spawn_timer.start()


func spawn_obj() -> void:
	var obj : ConveyorItem = spawnableObjects.pick_random().duplicate()
	#print("Spawn OBJECT:", get_node(obj.get_path_to(%StartingPath)) as Path2D)
	#obj.currentPath = get_node(obj.get_path_to(%StartingPath)) as Path2D
	#print("Spawn OBJECT:", %StartingPath as Path2D)
	obj.currentPath = %StartingPath as Path2D
	#obj.setPath(%StartingPath as Path2D)
	#print("Adding Child ", obj)
	obj.completedPath.connect(obj_run_complete)
	item_spawner.add_child(obj)

func obj_run_complete(path : Path2D, spritePath : String) -> void:
	#print("AN OBJECT HAS COMPLETED THE STEEL BALL RUN", path, spritePath)
	var pathName := path.name 
	if OutputToPath[pathName][1] == spritePath:
		print("BIG SUCCESS")
		AudioManager.play(SUCCESSAUDIO)
	else:
		print("INCORRECT SORT")
		if game_running:
			game_running = false
			Global.minigame_lost()
			AudioManager.play(DEATHAUDIO)
