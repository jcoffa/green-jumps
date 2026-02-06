extends Node

@export var levels: Array[PackedScene] = []

var _current_level := 0


func go_to_level(level_number: int) -> void:
	assert(level_exists(level_number),
			"No such level with number %s (levels are from 1-%s)" % [level_number, levels.size()])
	var ret := get_tree().change_scene_to_packed(levels[level_number-1])
	match ret:
		OK:
			_current_level = level_number
		ERR_CANT_CREATE:
			print("Couldn't create level %s" % level_number)
		ERR_INVALID_PARAMETER:
			print("Level %s is an invalid scene and couldn't be loaded" % level_number)


func level_exists(level_number: int) -> bool:
	return 0 <= level_number and level_number <= levels.size()


func is_last_level(level_number: int = 0) -> bool:
	if level_number == 0:
		return _current_level == levels.size()
	return level_number == levels.size()
