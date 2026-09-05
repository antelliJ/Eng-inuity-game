extends Control

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_settings_view() -> void:
	visible = !visible


func _on_close_pressed() -> void:
	Global.toggle_settings.emit()
	
func current_state() -> Global.GameStates:
	return Global.GameState
