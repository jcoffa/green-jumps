class_name Player
extends CharacterBody2D

const JUMP_SOUND: AudioStream = preload("uid://c70hcbq5jh8kc")
const DASH_SOUND: AudioStream = preload("uid://caftjw0hndhwg")
const DIE_SOUND: AudioStream = preload("uid://bfwxk46idfg5l")
const JUMP_PARTICLES := preload("uid://n8klc8x0x55t")


var _powerups: Array[Powerup] = []

@export var move_speed := 130.0

# Retrived from https://youtu.be/IOe1aGY6hXA, adjusted for Godot v4.x
@export_group("Jumping")
@export_range(1.0, 500.0, 10.0) var jump_height: float = 100.0
@export_range(0.01, 10.0, 0.01) var jump_time_to_peak: float = 0.5
@export_range(0.01, 10.0, 0.01) var jump_time_to_descent: float = 0.4
@export_group("Dashing")
@export_range(1.0, 2000.0, 10.0) var dash_speed: float = 700.0

var is_dashing: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var dash_timer: Timer = $DashTimer
@onready var death_timer: Timer = $DeathTimer

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func _ready() -> void:
	dash_timer.one_shot = true
	dash_timer.timeout.connect(func(): is_dashing = false)
	death_timer.one_shot = true
	death_timer.timeout.connect(func(): get_tree().reload_current_scene())


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not (is_dashing or is_on_floor()):
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
	if is_dashing:
		velocity.x = move_toward(velocity.x, move_speed, absf(absf(velocity.x) - move_speed) * (dash_timer.wait_time - dash_timer.time_left))
	elif direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	move_and_slide()


func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func set_camera_limits(limit_right: float, limit_top: float) -> void:
	var viewport := get_viewport().get_visible_rect().size
	var minimum := Vector2(
		floor(viewport.x / camera_2d.zoom.x),
		# I do not understand why we need to double the Y to get the right number, but it works!
		floor(viewport.y / camera_2d.zoom.y) * 2
	)
	camera_2d.limit_right = max(limit_right, minimum.x)
	camera_2d.limit_top = min(limit_top, minimum.y)	# min() because small values of Y is higher ("-Y is up")


func jump():
	SfxPlayer.play(JUMP_SOUND)
	add_child(JUMP_PARTICLES.instantiate())
	velocity.y = jump_velocity


# TODO: add squishing to the sprite when dashing
#	if squish is active (sprite scale != 1.0), then move_toward() normal sprite
#	scale by a small amount every frame. Is there a way to do this so that we always
#	squish in the direction of the dash?
func dash():
	SfxPlayer.play(DASH_SOUND)
	var direction = -1 if animated_sprite.flip_h else 1
	velocity = Vector2(direction * dash_speed, 0)
	is_dashing = true
	dash_timer.start()


func die():
	MusicPlayer.stop()
	SfxPlayer.play(DIE_SOUND)
	set_physics_process(false)
	death_timer.start()
	animated_sprite.play("die")
	death_particles.emitting = true


func add_powerup(powerup: Powerup) -> void:
	var num_powerups = _powerups.size()
	assert(num_powerups <= Constants.MAX_POWERUPS,
			"Number of powerups exceeds the limit of %s; is %s" % [Constants.MAX_POWERUPS, num_powerups])

	if num_powerups < Constants.MAX_POWERUPS:
		_powerups.push_back(powerup)
		EventBus.powerup_gained.emit(powerup)
	else:
		powerup.activate(self)


func use_powerup() -> void:
	if _powerups.is_empty():
		return
	var powerup = _powerups.pop_front()
	powerup.activate(self)
	EventBus.powerup_used.emit(powerup)
