extends Node2D

@onready var life_container: HBoxContainer = $LifeContainer
@onready var life_1: TextureRect = $LifeContainer/Life1
@onready var life_2: TextureRect = $LifeContainer/Life2
@onready var life_3: TextureRect = $LifeContainer/Life3
@onready var life_4: TextureRect = $LifeContainer/Life4
@onready var life_5: TextureRect = $LifeContainer/Life5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer

var time : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await Timer(5.0)
	
	if Global.minigames_done < 3:
		Global.minigames_done += 1
		#get_tree().change_scene_to_file("res://scenes/minigame_" + str(Global.minigames_done) + ".tscn") # changes your scene by arranging this frankenstein path.
		##TODO
		#change scene to the proper thing based off list
	else:
		get_tree().change_scene_to_file("res://TitleScreen/title_screen.tscn") # changes your scene
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Global.lives:
		4: 
			life_1.hide()
		3: 
			life_1.hide()
			life_2.hide()
		2:
			life_1.hide()
			life_2.hide()
			life_3.hide()
		1:
			life_1.hide()
			life_2.hide()
			life_3.hide()
			life_4.hide()
		0:
			life_container.hide()
	timer.text = str(time)
	level.text = "Level "+str(Global.minigames_done)


func Timer(start_time: float):
	time = start_time
	while time > 0.0:
		await wait(0.1)
		time -= 1
	
	return
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
