class_name MainMenu
extends Control

const TITLE_THEME = preload("uid://bd3qi5dv02mmb")
const LEVEL_THEME = preload("uid://0xjv5ebotqr2")


func _ready() -> void:
	SfxPlayer.stop()
	if not MusicPlayer.is_playing(TITLE_THEME):
		MusicPlayer.play(TITLE_THEME, true)


func _on_play_button_button_up() -> void:
	MusicPlayer.play(LEVEL_THEME, true)
	LevelManager.go_to_level(1)


func _on_level_select_button_pressed() -> void:
	# Can't preload due to circular reference
	get_tree().change_scene_to_file("res://user_interface/level_select_menu.tscn")


func _on_quit_button_button_up() -> void:
	get_tree().quit()
