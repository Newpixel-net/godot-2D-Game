extends Node2D
## Main - Main game scene controller
##
## Manages:
## - Portal spawning
## - Camera following player
## - Parallax background
## - Game initialization

# Portal spawning configuration
const PORTAL_SCENE = preload("res://scenes/portal.tscn")
const MIN_SPAWN_INTERVAL = 2.0  # Seconds
const MAX_SPAWN_INTERVAL = 4.0
const SPAWN_DISTANCE = 800.0  # Distance ahead of player to spawn portals

# Game state
var spawn_timer: float = 0.0
var next_spawn_time: float = 3.0

# References to nodes
@onready var player = $Player
@onready var wheel = $UILayer/Wheel
@onready var camera = $Camera2D
@onready var portal_container = $Portals
@onready var background = $ParallaxBackground

func _ready():
	# Initialize autoload if not already done
	if not has_node("/root/GameManager"):
		print("Warning: GameManager autoload not found!")

	# Set initial camera position
	if camera and player:
		camera.global_position = player.global_position

	# Set initial spawn time
	next_spawn_time = randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)

	print("Main scene ready!")
	print("Use Arrow Keys or A/D to rotate the wheel")
	print("Match the portal colors to score points!")

func _process(delta):
	# Update camera to follow player
	update_camera()

	# Handle portal spawning
	if GameManager and GameManager.is_playing():
		handle_portal_spawning(delta)

	# Update parallax speed based on game speed
	update_parallax()

## Update camera to follow player smoothly
func update_camera():
	if not camera or not player:
		return

	# Camera follows player horizontally, stays fixed vertically
	var target_pos = player.global_position
	target_pos.y = 0  # Keep camera at a fixed vertical position

	# Smooth camera movement
	camera.global_position = camera.global_position.lerp(target_pos, 0.1)

## Handle spawning new portals
func handle_portal_spawning(delta):
	spawn_timer += delta

	if spawn_timer >= next_spawn_time:
		spawn_portal()
		spawn_timer = 0.0

		# Calculate next spawn time (gets faster as game progresses)
		var speed_factor = GameManager.game_speed / GameManager.MAX_SPEED
		var adjusted_min = lerp(MIN_SPAWN_INTERVAL, 1.0, speed_factor)
		var adjusted_max = lerp(MAX_SPAWN_INTERVAL, 2.0, speed_factor)
		next_spawn_time = randf_range(adjusted_min, adjusted_max)

## Spawn a new portal
func spawn_portal():
	if not player or not wheel:
		return

	# Create new portal instance
	var portal = PORTAL_SCENE.instantiate()

	# Get random animal from wheel
	var animal_name = wheel.get_random_animal_name()
	var animal_color = get_animal_color_by_name(animal_name)

	# Position portal ahead of player
	var spawn_x = player.global_position.x + SPAWN_DISTANCE
	var spawn_y = 0  # Center of screen

	portal.global_position = Vector2(spawn_x, spawn_y)

	# Initialize the portal
	portal.initialize(animal_name, animal_color, wheel)

	# Add to portal container
	portal_container.add_child(portal)

	print("Spawned portal at x:", spawn_x)

## Get animal color by name from wheel's animal data
func get_animal_color_by_name(animal_name: String) -> Color:
	if not wheel:
		return Color.WHITE

	# Access wheel's animals array
	for animal in wheel.animals:
		if animal.name == animal_name:
			return animal.color

	return Color.WHITE

## Update parallax scrolling speed
func update_parallax():
	if not background or not GameManager:
		return

	# Scale parallax motion based on game speed
	var speed_factor = GameManager.game_speed / 200.0  # 200 is base speed

	# The parallax background will scroll automatically based on camera movement
	# We can adjust the scroll scale if needed
	for layer in background.get_children():
		if layer is ParallaxLayer:
			# Adjust motion scale based on game speed
			pass  # Motion is automatic with camera movement

## Called when game restarts
func restart_game():
	# Clear all portals
	for portal in portal_container.get_children():
		portal.queue_free()

	# Reset spawn timer
	spawn_timer = 0.0
	next_spawn_time = randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)

	# Reset player position
	if player:
		player.global_position = Vector2(0, 0)

	# Reset camera
	if camera:
		camera.global_position = Vector2(0, 0)

	# Reset game manager
	if GameManager:
		GameManager.reset_game()

	print("Game restarted!")
