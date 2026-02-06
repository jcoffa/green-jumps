class_name MainMenu
extends Control


func _on_play_button_button_up() -> void:
	LevelManager.go_to_level(1)


func _on_level_select_button_pressed() -> void:
	print("TODO: Open Level Selector!")


func _on_quit_button_button_up() -> void:
	get_tree().quit()
