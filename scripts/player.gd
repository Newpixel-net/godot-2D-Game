## Player character controller
##
## Handles player movement, jumping, color changes, and animations.
## The player stays at a fixed horizontal position while the background scrolls.
## Emits signals when color changes or important events occur.
##
## @tutorial: See docs/ASSET_INTEGRATION.md for sprite replacement

extends CharacterBody2D
class_name Player

## Jump force applied when jump is triggered (negative = upward)
@export var jump_force: float = -400.0

## Gravity acceleration applied each frame
@export var gravity: float = 980.0

## Fixed horizontal position on screen
@export var screen_position_x: float = 200.0

## Available colors that player can switch to
@export var available_colors: Array[String] = [
	"blue", "red", "green", "yellow",
	"purple", "orange", "pink", "brown"
]

## Current player color (affects matching with wheel)
var current_color: String = "blue"

## Reference to animated sprite
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var jump_particles: CPUParticles2D = $JumpParticles

## Emitted when player successfully changes color
signal color_changed(new_color: String)

## Emitted when player jumps
signal jumped

func _ready() -> void:
	# Set fixed horizontal position
	position.x = screen_position_x

	# Start running animation
	if animated_sprite:
		animated_sprite.play("run")

	# Set initial color
	set_color(current_color)

	print("[Player] Ready! Starting color: ", current_color)

func _physics_process(delta: float) -> void:
	# Apply gravity if not on floor
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# On floor - make sure running animation plays
		if animated_sprite and animated_sprite.animation != "run":
			animated_sprite.play("run")

	# Always maintain fixed horizontal position
	position.x = screen_position_x

	# Handle movement (vertical only)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Handle jump input
	if event.is_action_pressed("jump"):
		jump()

## Trigger a jump if player is on the ground
func jump() -> void:
	if is_on_floor():
		velocity.y = jump_force

		# Play jump animation
		if animated_sprite:
			animated_sprite.play("jump")

		# Trigger jump particles
		if jump_particles:
			jump_particles.restart()

		# Emit signal for audio/effects
		jumped.emit()

		print("[Player] Jumped!")

## Change the player's color
## @param color: String name of the color (must be in available_colors)
func set_color(color: String) -> void:
	if color not in available_colors:
		push_error("[Player] Invalid color: " + color)
		return

	current_color = color
	update_visual_color()
	color_changed.emit(color)

	print("[Player] Color changed to: ", color)

## Update the visual appearance to match current color
## PLACEHOLDER: Uses modulate. Replace with sprite sheet switching when assets ready
func update_visual_color() -> void:
	if not animated_sprite:
		return

	# Map color names to Color values (PLACEHOLDER)
	var color_map: Dictionary = {
		"blue": Color(0.2, 0.6, 1.0),
		"red": Color(1.0, 0.2, 0.2),
		"green": Color(0.2, 1.0, 0.2),
		"yellow": Color(1.0, 1.0, 0.2),
		"purple": Color(0.8, 0.2, 1.0),
		"orange": Color(1.0, 0.6, 0.2),
		"pink": Color(1.0, 0.4, 0.8),
		"brown": Color(0.6, 0.4, 0.2)
	}

	if current_color in color_map:
		animated_sprite.modulate = color_map[current_color]

		# Also update particle color
		if jump_particles:
			jump_particles.color = color_map[current_color]

## Get current color name
func get_current_color() -> String:
	return current_color

## Play idle animation (when game is paused/over)
func play_idle() -> void:
	if animated_sprite:
		animated_sprite.play("idle")

## Play run animation (when game is active)
func play_run() -> void:
	if animated_sprite:
		animated_sprite.play("run")
