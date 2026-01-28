class_name PowerupUI
extends PanelContainer

@export var powerup: Powerup:
	set(value):
		powerup = value
		update_visuals()

@onready var texture_rect: TextureRect = %TextureRect


func _ready() -> void:
	update_visuals()


func update_visuals() -> void:
	if powerup:
		texture_rect.texture = powerup.image
	else:
		texture_rect.texture = null
