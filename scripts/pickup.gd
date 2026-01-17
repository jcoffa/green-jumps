class_name Pickup
extends Area2D

@export var powerup: Powerup

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.self_modulate = powerup.color


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if not player:
		return
	player.add_powerup(powerup)
	queue_free()
