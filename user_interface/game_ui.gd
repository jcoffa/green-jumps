class_name GameUI
extends CanvasLayer

@onready var level_name_display: LevelNameDisplay = $LevelNameDisplay


func init_level_ui(level_number: int, level_name: String, level_name_color := Color.WHITE) -> void:
	level_name_display.level_number = level_number
	level_name_display.level_name = level_name
	level_name_display.color = level_name_color
	level_name_display.update_visuals()
