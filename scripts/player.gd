class_name Player
extends CharacterBody2D

const MAX_POWERUPS := 3

var powerups: Array[Powerup] = []

@export var move_speed := 130.0

# Retrived from https://youtu.be/IOe1aGY6hXA, adjusted for Godot v4.x
@export_group("Jumping")
@export_range(0.0, 500.0, 10.0) var jump_height: float = 100.0
@export_range(0.01, 10.0, 0.01) var jump_time_to_peak: float = 0.5
@export_range(0.01, 10.0, 0.01) var jump_time_to_descent: float = 0.4

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += _get_gravity() * delta

	if Input.is_action_just_pressed("use_powerup"):
		use_powerup()

	# Get the input direction: one of -1, 0, or 1
	var direction := Input.get_axis("move_left", "move_right")

	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Apply movement
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	move_and_slide()


func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func jump():
	velocity.y = jump_velocity


func add_powerup(powerup: Powerup) -> void:
	var num_powerups = len(powerups)
	assert(num_powerups <= MAX_POWERUPS,
			"Number of powerups exceeds the limit of %s; is %s" % [MAX_POWERUPS, num_powerups])

	if num_powerups < MAX_POWERUPS:
		powerups.push_back(powerup)
	else:
		powerup.activate(self)


func use_powerup() -> void:
	if powerups.is_empty():
		return
	powerups.pop_front().activate(self)
