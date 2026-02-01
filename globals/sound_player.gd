extends Node


func play(stream: AudioStream, single := false) -> void:
	if not stream:
		return

	if single:
		stop()

	# Find an unoccupied player to play the sound
	for player: AudioStreamPlayer in get_children():
		if player.playing:
			continue
		player.stream = stream
		player.play()
		return
	assert(false, "All players are full, could not play sound located at <%s>" % stream.resource_path)


func stop() -> void:
	for player: AudioStreamPlayer in get_children():
		player.stop()
