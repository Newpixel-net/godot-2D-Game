extends Area2D
## Portal - The colored gates that player must match
##
## Features:
## - Has a required animal/color
## - Checks if player's wheel matches when passing through
## - Visual feedback (green flash for correct, red for wrong)
## - Automatically removes itself when off-screen

# Portal configuration
const PORTAL_WIDTH = 40.0
const PORTAL_HEIGHT = 200.0
const FLASH_DURATION = 0.3

# Portal state
var required_animal: String = ""
var required_color: Color = Color.WHITE
var has_been_checked: bool = false
var is_flashing: bool = false
var flash_timer: float = 0.0
var flash_color: Color = Color.WHITE

# References
var wheel_reference = null
@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D
@onready var label = $Label

func _ready():
	# Connect to player entering the portal
	body_entered.connect(_on_body_entered)

	# Set up the portal visuals
	setup_portal()

func _process(delta):
	# Handle flash animation
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0:
			is_flashing = false
			# Reset to original color
			if sprite:
				sprite.modulate = Color.WHITE

	# Check if portal is off-screen (far to the left)
	# Remove it to save memory
	if global_position.x < -500:
		queue_free()

## Set up the portal with a required animal
func setup_portal():
	# This will be called after wheel reference is set
	pass

## Initialize the portal with required animal and wheel reference
func initialize(animal_name: String, animal_color: Color, wheel_ref):
	required_animal = animal_name
	required_color = animal_color
	wheel_reference = wheel_ref

	# Update label
	if label:
		label.text = animal_name
		label.add_theme_font_size_override("font_size", 16)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		label.add_theme_constant_override("outline_size", 2)

	# Update sprite color (will use required_color in the sprite)
	if sprite:
		sprite.modulate = required_color

	print("Portal created - Required animal: ", required_animal)

## Called when player enters the portal
func _on_body_entered(body):
	if has_been_checked:
		return  # Already checked this portal

	if body.name == "Player":
		has_been_checked = true
		check_match()

## Check if the player's wheel matches the required animal
func check_match():
	if not wheel_reference:
		print("Error: Wheel reference not set!")
		return

	var player_animal = wheel_reference.get_current_animal_name()
	print("Checking match - Required: ", required_animal, " | Player has: ", player_animal)

	if player_animal == required_animal:
		# Correct match!
		on_correct_match()
	else:
		# Wrong match!
		on_wrong_match()

## Handle correct match
func on_correct_match():
	print("✓ CORRECT MATCH!")

	# Visual feedback - green flash
	flash(Color.GREEN)

	# Update game manager
	if GameManager:
		GameManager.add_score()

	# Remove portal after a short delay
	await get_tree().create_timer(0.2).timeout
	queue_free()

## Handle wrong match
func on_wrong_match():
	print("✗ WRONG MATCH!")

	# Visual feedback - red flash
	flash(Color.RED)

	# Update game manager
	if GameManager:
		GameManager.add_wrong()

	# Remove portal after a short delay
	await get_tree().create_timer(0.2).timeout
	queue_free()

## Flash the portal with a color
func flash(color: Color):
	is_flashing = true
	flash_timer = FLASH_DURATION
	flash_color = color

	if sprite:
		sprite.modulate = color
