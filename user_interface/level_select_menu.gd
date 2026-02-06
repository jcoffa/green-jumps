class_name LevelSelectMenu
extends Control

const GO_TO_LEVEL_BUTTON = preload("uid://b7ovokxn6383o")

@onready var levels: GridContainer = %Levels


func _ready() -> void:
	# Clear the levels children just in case I left in any buttons while testing
	for child in levels.get_children():
		levels.remove_child(child)
		child.queue_free()

	for i in range(LevelManager.levels.size()):
		var button := GO_TO_LEVEL_BUTTON.instantiate() as GoToLevelButton
		button.level_number = i + 1
		levels.add_child(button)


func _on_back_button_pressed() -> void:
	# Can't preload due to circular reference
	get_tree().change_scene_to_file("res://user_interface/main_menu.tscn")
