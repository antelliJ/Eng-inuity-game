extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.pauseGameSignal.connect(togglePauseVisible)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func togglePauseVisible(open:bool)->void:
	if !open:
		visible = false
	#visible = !visible

func _on_continue_btn_pressed() -> void:
	Global.pauseGameSignal.emit(false)


func _on_audio_slider_value_changed(value: float) -> void:
	AudioManager.AudioVol = value


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.MusicVol = value
