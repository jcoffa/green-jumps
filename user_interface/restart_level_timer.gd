class_name RestartLevelTimer
extends Control

@onready var timer: Timer = $Timer
@onready var progress_bar: TextureProgressBar = %TextureProgressBar


func _ready() -> void:
	visible = false

	# Failsafe for if I don't change it in the editor since these values are dependent
	progress_bar.max_value = timer.wait_time
	progress_bar.step = 0.1

	# Restart level on timeout
	timer.timeout.connect(func():
		get_tree().reload_current_scene()
	)


func _process(_delta: float) -> void:
	progress_bar.value = timer.wait_time - timer.time_left


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		visible = true
		timer.start()
	elif event.is_action_released("restart"):
		visible = false
		timer.stop()
