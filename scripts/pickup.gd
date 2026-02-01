@tool
class_name Pickup
extends Area2D

const PICKUP_SOUND: AudioStream = preload("uid://dr2xxqqgda1uc")

@export var powerup: Powerup:
	set(value):
		powerup = value
		update_visuals()
		update_configuration_warnings()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	update_visuals()


func update_visuals() -> void:
	if not is_node_ready():
		return
	if powerup:
		animated_sprite.self_modulate = powerup.color
	else:
		animated_sprite.self_modulate = Color.WHITE


func _get_configuration_warnings() -> PackedStringArray:
	var to_return = []
	if not powerup:
		to_return.append("No powerup has been assigned")
	return to_return


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if not player:
		return
	SfxPlayer.play(PICKUP_SOUND)
	player.add_powerup(powerup)
	queue_free()
