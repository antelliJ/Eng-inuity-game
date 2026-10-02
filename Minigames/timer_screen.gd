extends Control

@onready var life_container: HBoxContainer = $LifeContainer
@onready var life_1: TextureRect = $LifeContainer/Life1
@onready var life_2: TextureRect = $LifeContainer/Life2
@onready var life_3: TextureRect = $LifeContainer/Life3
@onready var life_4: TextureRect = $LifeContainer/Life4
@onready var life_5: TextureRect = $LifeContainer/Life5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer

var time : float
const DEATHAUDIO := "uid://d0ek5a3mvhbk2"

#ordered based on the way they should disappear
@onready var lifeTextures:Array[TextureRect] = [
	life_1,
	life_5,
	life_2,
	life_4,
	life_3,
]
@onready var life_for_anim: TextureRect = $LifeForAnim
@onready var simulated_spacing: TextureRect = $LifeContainer/Simulated
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life_for_anim.hide()
	simulated_spacing.hide()
	if Transition.visible:
		await Transition.animation.animation_finished
	#await _physics_process()
	
	if Global.GameWon != Global.GameWinStates.WON and (Global.lives < lifeTextures.size()):
		print(lifeTextures[lifeTextures.size() - 1 - Global.lives])
		play_life_byebye_anim(lifeTextures[lifeTextures.size() - 1 - Global.lives])
	
	await Timer(15.0)
	
	if Global.minigameIndex < Global.MinigamesList.minigames.size():
		#Global.minigames_done += 1
		Global.next_minigame()
		#get_tree().change_scene_to_file("res://scenes/minigame_" + str(Global.minigames_done) + ".tscn") # changes your scene by arranging this frankenstein path.
		##TODO
		#change scene to the proper thing based off list
	else:
		#get_tree().change_scene_to_file("res://TitleScreen/title_screen.tscn") # changes your scene
		Transition.playTransition("res://TitleScreen/game_over.tscn")
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	hide_lives()
	
	timer.text = str(time)
	level.text = "Level "+str(Global.minigames_done)

func hide_lives() -> void:
	#await animation_player.animation_finished
	
	match Global.lives:
		4: 
			life_1.hide()
		3: 
			life_1.hide()
			life_5.hide()
		2:
			life_1.hide()
			life_5.hide()
			life_2.hide()
		1:
			life_1.hide()
			life_5.hide()
			life_2.hide()
			life_4.hide()
		0:
			life_container.hide()
	

func play_life_byebye_anim(choice: TextureRect)->void:
	AudioManager.play(DEATHAUDIO)
	hide_lives()
	simulated_spacing.show()
	life_container.queue_sort()
	await get_tree().process_frame
	animation_player.play("RESET")
	#animate shrink and scale then pop / disappear
	# 232 + 136x
	#var anim_pos : Vector2 = Vector2(
		## 136x -> 185x
		#life_1.global_position.x + (128.0 * (Global.lives)) + 8*(Global.lives+1),# + 56.0),
		#life_1.global_position.y)
	#life_for_anim.set_position(choice.global_position)
	var anim_pos :Vector2 = simulated_spacing.global_position
	life_for_anim.set_global_position(anim_pos)
	
	print("Setting animation pos to ", choice.global_position)
	#animation_player.speed_scale = 0.25
	animation_player.play("lifeLost")

func Timer(start_time: float):
	time = start_time
	while time > 0.0:
		await wait(0.1)
		time -= 1
	
	return
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds, false).timeout
