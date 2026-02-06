extends Node

@export var levels: Array[PackedScene] = []


func go_to_level(level_number: int) -> void:
	assert(1 <= level_number and level_number <= levels.size(),
			"No such level with number %s (levels are from 1-%s)" % [level_number, levels.size()])
	get_tree().change_scene_to_packed(levels[level_number-1])
