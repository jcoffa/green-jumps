class_name VictoryScreen
extends Control

const WIN_THEME = preload("uid://caljtrq7810gx")
const TITLE_THEME = preload("uid://bd3qi5dv02mmb")


func _ready() -> void:
	MusicPlayer.play(WIN_THEME, true,
		func():
			await get_tree().create_timer(1.0).timeout
			MusicPlayer.play(TITLE_THEME, true)
	)
