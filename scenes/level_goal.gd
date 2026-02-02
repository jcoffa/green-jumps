class_name LevelGoal
extends Node2D

@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	var player := body as Player
	if not player:
		return
	EventBus.level_goal_reached.emit()
	area_2d.set_deferred("monitoring", false)
	area_2d.set_deferred("monitorable", false)
