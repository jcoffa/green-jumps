class_name VolumeSlider
extends VBoxContainer
# Made with help from:
#	https://shaggydev.com/2023/05/22/volume-sliders/
#	https://youtu.be/aFkRmtGiZCw

const VOLUME_TICK = preload("uid://ds0qy0q711cqx")

# Unfortunately I could not figure out how to make this a nice dropdown menu
# to limit it to the names of our existing buses, like how the AudioStreamPlayer
# nodes work.
@export var bus_name: String
## Play a brief note when the slider is moved.
@export var make_tick_sound: bool = false

# Functions that work with audio buses will identify the bus by index, not
# by name. However, we can get the index by its name so it's helpful to store
# this value somewhere. We populate this in the _ready() method as it only needs
# to be set once.
var _bus_index: int

@onready var label: Label = %Label
@onready var volume_slider: HSlider = %VolumeSlider


func _ready() -> void:
	label.text = bus_name
	_bus_index = AudioServer.get_bus_index(bus_name)

	# Ensure the slider defaults to the current volume of this particular bus.
	# This is why we have to initially mute the player.
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))

	# Important to connect the signal *after* defaulting the slider in the line above
	# so that the game does not play the "tick sound" on startup.
	volume_slider.value_changed.connect(change_volume)


func change_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
	if make_tick_sound:
		SfxPlayer.play(VOLUME_TICK, true)
