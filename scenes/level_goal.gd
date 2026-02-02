class_name LevelGoal
extends Node2D

const WIN_SOUND := preload("uid://rtr6j7im6wng")

@onready var area_2d: Area2D = $Area2D
@onready var particles: GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	particles.emitting = false
	particles.one_shot = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	var player := body as Player
	if not player:
		return
	EventBus.level_goal_reached.emit()
	SfxPlayer.play(WIN_SOUND)
	particles.emitting = true
	area_2d.set_deferred("monitoring", false)
	area_2d.set_deferred("monitorable", false)
