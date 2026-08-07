class_name TransitionManager extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#playTransition()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and Engine.is_editor_hint():
		playTransition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playTransition(newScene : String = "")->void:
	visible = true
	animation.play("TransitionOut")
	await animation.animation_finished
	#	change scene here
	if !newScene.is_empty(): # and ResourceLoader.exists(newScene)
		print("CHANGING SCENE TO FILE "+newScene)
		get_tree().change_scene_to_file(newScene)
	
	animation.play_backwards("TransitionOut")
	await animation.animation_finished
	visible = false
	
func playTransitionIn()->void:
	visible = true
	animation.play("TransitionIn")
	await animation.animation_finished
	visible = false

func playTransitionOut()->void:
	visible = true
	animation.play("TransitionOut")
	await animation.animation_finished
	visible = false
