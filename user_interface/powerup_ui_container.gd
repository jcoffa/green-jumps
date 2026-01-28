class_name PowerupUIContainer
extends Control

const POWERUP_UI = preload("uid://oaupitydrmtk")

@export var _powerups: Array[Powerup] = []:
	set(value):
		assert(value.size() <= Constants.MAX_POWERUPS,
				"Can't have more than %s powerups" % Constants.MAX_POWERUPS)
		_powerups = value
		update_powerup_display()

@onready var h_box_container: HBoxContainer = %HBoxContainer


func _ready() -> void:
	# Clear all PowerupUIs since I usually leave some there in order to make
	# this UI visible in the editor.
	for child in h_box_container.get_children():
		h_box_container.remove_child(child)
		child.queue_free()

	# PowerupUIs will automatically update their own visuals when their powerup
	# changes (or is removed), so we can pre-create all of them and then never
	# have to make any more.
	for i in Constants.MAX_POWERUPS:
		h_box_container.add_child(POWERUP_UI.instantiate())
	update_powerup_display()

	EventBus.powerup_gained.connect(func(powerup):
		assert(_powerups.size() <= Constants.MAX_POWERUPS,
			"Can't have more than %s powerups" % Constants.MAX_POWERUPS)
		_powerups.append(powerup)
		update_powerup_display()
	)
	EventBus.powerup_used.connect(func(powerup):
		assert(_powerups.front() == powerup,
			"Removing a powerup (%s) that's not the front (%s)" % [powerup, _powerups.front()])
		_powerups.pop_front()
		update_powerup_display()
	)


# Force all the individual PowerupUIs to update their own visuals by syncing
# their powerups with the version we're keeping track of based on the signals
# coming from the Pickups and Player.
func update_powerup_display() -> void:
	for i in Constants.MAX_POWERUPS:
		var ui := h_box_container.get_child(i) as PowerupUI
		if i < _powerups.size():
			ui.powerup = _powerups[i]
		else:
			ui.powerup = null
