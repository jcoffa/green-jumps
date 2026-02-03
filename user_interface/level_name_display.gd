@tool
class_name LevelNameDisplay
extends Control

@export_range(0, 100) var level_number: int = 1
@export var level_name: String = "Green Jumps"
@export var color: Color = Color.WHITE
# Use a tool button instead of setter properties because updating a String moves
# the cursor to the start of the text box after every keypress, which makes it
# basically impossible to type and have it update the label text in-place.
@export_tool_button("Update visuals") var update_visuals_action = update_visuals

@onready var label: RichTextLabel = %RichTextLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	update_visuals()
	if label.text == null or label.text.is_empty():
		hide()


func fade_out() -> void:
	animation_player.play("fade_out")


func update_visuals() -> void:
	label.text = "Level {} - [color={}]{}[/color]".format([level_number, color.to_html(), level_name], "{}")
	notify_property_list_changed()
