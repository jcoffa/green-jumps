class_name MainMenu
extends Control

const LEVEL_THEME = preload("uid://0xjv5ebotqr2")


func _ready() -> void:
	SfxPlayer.stop()
	# TODO replace with main-menu theme (if we have one)
	if not MusicPlayer.is_playing(LEVEL_THEME):
		MusicPlayer.play(LEVEL_THEME, true)


func _on_play_button_button_up() -> void:
	# TODO remove if we DON'T have a main-menu them to switch off of (since it
	# will already be playing the level theme)
	MusicPlayer.play(LEVEL_THEME, true)
	LevelManager.go_to_level(1)


func _on_level_select_button_pressed() -> void:
	# Can't preload due to circular reference
	get_tree().change_scene_to_file("res://user_interface/level_select_menu.tscn")


func _on_quit_button_button_up() -> void:
	get_tree().quit()
