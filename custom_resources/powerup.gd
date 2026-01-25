@abstract
class_name Powerup
extends Resource

## Human-readable identifier for the powerup. Often just the name of the power.
@export var id: String
## The color of the pickup in the game world.
@export var color: Color = Color.WHITE


@abstract
func activate(_player: Player) -> void


func _to_string() -> String:
	return id
