class_name RestartLevelTimer
extends Control

const VOLUME_TICK = preload("uid://ds0qy0q711cqx")

@onready var restart_timer: Timer = $RestartTimer
@onready var tick_sound_timer: Timer = $TickSoundTimer
@onready var progress_bar: TextureProgressBar = %TextureProgressBar


func _ready() -> void:
	visible = false

	# Failsafe for if I don't change it in the editor since these values are dependent
	progress_bar.max_value = restart_timer.wait_time
	progress_bar.step = 0.1

	# Restart level on timeout
	restart_timer.timeout.connect(func():
		get_tree().reload_current_scene()
	)
	# Play tick sound every so often
	tick_sound_timer.timeout.connect(func():
		SfxPlayer.play(VOLUME_TICK)
		tick_sound_timer.call_deferred("start")
	)


func _process(_delta: float) -> void:
	progress_bar.value = restart_timer.wait_time - restart_timer.time_left


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		visible = true
		restart_timer.start()
		tick_sound_timer.start()
		SfxPlayer.play(VOLUME_TICK)
	elif event.is_action_released("restart"):
		visible = false
		restart_timer.stop()
		tick_sound_timer.stop()
