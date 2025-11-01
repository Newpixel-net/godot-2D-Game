## Portal gate obstacle
##
## Gates that the player must pass through with the correct color match.
## Portals move from right to left at a constant speed.
## Collision detection triggers match checking against the color wheel.
##
## @tutorial: See docs/ASSET_INTEGRATION.md for portal sprite replacement

extends Area2D
class_name Portal

## Speed at which portal moves left (should match background scroll speed)
@export var move_speed: float = -200.0

## Required color name for this portal
var required_color: String = ""

## Has this portal been checked yet?
var is_passed: bool = false

## Reference to visual elements
@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label
@onready var particles: CPUParticles2D = $Particles

## Emitted when player passes through correctly
signal portal_passed_correct

## Emitted when player passes through incorrectly
signal portal_passed_wrong

## Color map for visual representation
var color_map: Dictionary = {
	"blue": Color(0.2, 0.6, 1.0, 0.6),
	"red": Color(1.0, 0.2, 0.2, 0.6),
	"green": Color(0.2, 1.0, 0.2, 0.6),
	"yellow": Color(1.0, 1.0, 0.2, 0.6),
	"purple": Color(0.8, 0.2, 1.0, 0.6),
	"orange": Color(1.0, 0.6, 0.2, 0.6),
	"pink": Color(1.0, 0.4, 0.8, 0.6),
	"brown": Color(0.6, 0.4, 0.2, 0.6)
}

func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)

	print("[Portal] Created - Required: ", required_color)

func _process(delta: float) -> void:
	# Move portal to the left
	position.x += move_speed * delta

	# Remove portal when it goes off-screen (left side)
	if position.x < -150:
		queue_free()
		print("[Portal] Despawned (off-screen)")

## Initialize the portal with required color
func initialize(color: String) -> void:
	required_color = color

	# Update visual appearance
	if sprite:
		sprite.color = color_map.get(color, Color.WHITE)

	# Update label
	if label:
		label.text = color.capitalize()
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		label.add_theme_constant_override("outline_size", 3)

	print("[Portal] Initialized with color: ", color)

## Handle player entering the portal
func _on_body_entered(body: Node2D) -> void:
	# Prevent multiple checks
	if is_passed:
		return

	# Only check if it's the player
	if not body is Player:
		return

	is_passed = true
	var player: Player = body as Player

	# Get player's current color
	var player_color: String = player.get_current_color()

	print("[Portal] Player entered - Required: ", required_color, " | Player: ", player_color)

	# Check if colors match
	if player_color == required_color:
		handle_correct_match()
	else:
		handle_wrong_match()

## Handle correct color match
func handle_correct_match() -> void:
	print("[Portal] ✓ CORRECT MATCH!")

	# Emit signal
	portal_passed_correct.emit()

	# Create success particles
	create_success_particles()

	# Flash green
	flash_color(Color.GREEN)

	# Remove after brief delay
	await get_tree().create_timer(0.2).timeout
	queue_free()

## Handle wrong color match
func handle_wrong_match() -> void:
	print("[Portal] ✗ WRONG MATCH!")

	# Emit signal
	portal_passed_wrong.emit()

	# Create failure effect
	create_failure_effect()

	# Flash red
	flash_color(Color.RED)

	# Remove after brief delay
	await get_tree().create_timer(0.2).timeout
	queue_free()

## Flash the portal with a specific color
func flash_color(flash: Color) -> void:
	if not sprite:
		return

	var original_color: Color = sprite.color

	# Tween to flash color and back
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "color", flash, 0.1)
	tween.tween_property(sprite, "color", original_color, 0.1)

## Create green sparkle particles for success
func create_success_particles() -> void:
	if not particles:
		return

	particles.emitting = true
	particles.color = Color.GREEN
	particles.amount = 30
	particles.lifetime = 0.5
	particles.explosiveness = 1.0

## Create red warning effect for failure
func create_failure_effect() -> void:
	if not particles:
		return

	particles.emitting = true
	particles.color = Color.RED
	particles.amount = 20
	particles.lifetime = 0.3
	particles.explosiveness = 1.0

## Get the required color for this portal
func get_required_color() -> String:
	return required_color
