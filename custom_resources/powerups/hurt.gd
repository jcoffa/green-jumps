class_name Hurt
extends Powerup


func activate(player: Player) -> void:
	player.die()
