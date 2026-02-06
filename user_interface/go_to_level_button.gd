class_name GoToLevelButton
extends Button

@export_range(0, 100) var level_number: int = 0


func _ready() -> void:
	text = " Level %s " % level_number


func _on_pressed() -> void:
	LevelManager.go_to_level(level_number)
