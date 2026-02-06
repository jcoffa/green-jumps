class_name MainMenu
extends Control


func _on_play_button_button_up() -> void:
	LevelManager.go_to_level(1)


func _on_level_select_button_pressed() -> void:
	# Can't preload due to circular reference
	get_tree().change_scene_to_file("res://user_interface/level_select_menu.tscn")


func _on_quit_button_button_up() -> void:
	get_tree().quit()
