class_name Level
extends Node

const PLAYER_SCENE: PackedScene = preload("uid://cg8cr5s14uh4m")
const LEVEL_MUSIC: AudioStream = preload("uid://0xjv5ebotqr2")

@onready var game_ui: CanvasLayer = $GameUI
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var camera_limit: Marker2D = $CameraLimit


func _ready() -> void:
	# Sometimes I hide the UI in the editor because it can bother me while making
	# a level. Always ensure the UI is visible when actually running the scene!
	game_ui.visible = true

	# Reset sounds
	SfxPlayer.stop()
	MusicPlayer.play(LEVEL_MUSIC, true)

	# Connect level win signal
	EventBus.level_goal_reached.connect(func():
		# TODO handle winning a level better
		print("You win!")
		await get_tree().create_timer(3.0).timeout
		get_tree().quit()
	)

	# Add player to scene
	var player: Player = PLAYER_SCENE.instantiate()
	player.global_position = player_spawn.global_position
	add_child(player)

	# Change camera limits if needed
	var camera_limit_dimensions = camera_limit.global_position
	if camera_limit_dimensions != Vector2.ZERO:	# Don't change if the level hasn't moved the anchor
		player.set_camera_limits(camera_limit_dimensions.x, camera_limit_dimensions.y)
