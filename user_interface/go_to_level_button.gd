class_name GoToLevelButton
extends Button

const LEVEL_THEME = preload("uid://0xjv5ebotqr2")

@export_range(0, 100) var level_number: int = 0


func _ready() -> void:
	text = " Level %s " % level_number


func _on_pressed() -> void:
	MusicPlayer.play(LEVEL_THEME, true)
	LevelManager.go_to_level(level_number)
