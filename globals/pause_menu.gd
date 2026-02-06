extends CanvasLayer

@onready var pause_sound: AudioStreamPlayer = $PauseSound
@onready var unpause_sound: AudioStreamPlayer = $UnpauseSound

func _ready() -> void:
	hide()


func pause_game() -> void:
	pause_sound.play()
	show()
	get_tree().paused = true


func unpause_game() -> void:
	unpause_sound.play()
	hide()
	get_tree().paused = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			unpause_game()
		else:
			pause_game()
		get_viewport().set_input_as_handled()


func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()
