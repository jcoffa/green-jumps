class_name Level
extends Node

const PLAYER_SCENE: PackedScene = preload("uid://cg8cr5s14uh4m")
const LEVEL_MUSIC: AudioStream = preload("uid://0xjv5ebotqr2")

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var game_ui: CanvasLayer = $GameUI


func _ready() -> void:
	# Sometimes I hide the UI in the editor because it can bother me while making
	# a level. Always ensure the UI is visible when actually running the scene!
	game_ui.visible = true

	# Reset sounds
	SfxPlayer.stop()
	MusicPlayer.play(LEVEL_MUSIC, true)

	# Add player to scene
	var player: Player = PLAYER_SCENE.instantiate()
	player.global_position = player_spawn.global_position
	add_child(player)
