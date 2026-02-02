class_name Killzone
extends Area2D

const DIE_SOUND := preload("uid://bfwxk46idfg5l")

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	print("You died! Loser!")
	MusicPlayer.stop()
	SfxPlayer.play(DIE_SOUND)
	timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
