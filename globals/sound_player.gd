extends Node


func play(stream: AudioStream, single := false, callback = null) -> void:
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
		if callback != null:
			player.finished.connect(callback)
		return
	assert(false, "All players are full, could not play sound located at <%s>" % stream.resource_path)


func stop() -> void:
	for player: AudioStreamPlayer in get_children():
		player.stop()


func is_playing(stream: AudioStream) -> bool:
	if not stream:
		return false

	for player: AudioStreamPlayer in get_children():
		if player.playing and player.stream == stream:
			return true
	return false
