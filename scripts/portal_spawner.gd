## Portal Spawner
##
## Manages the spawning of portal obstacles at regular intervals.
## Portals spawn at the right edge of the screen and move left.
## Spawn timing becomes faster as difficulty increases.

extends Node2D
class_name PortalSpawner

## Portal scene to instantiate
@export var portal_scene: PackedScene

## Minimum time between spawns (seconds)
@export var min_spawn_time: float = 4.0

## Maximum time between spawns (seconds)
@export var max_spawn_time: float = 6.0

## X position where portals spawn (right edge of screen)
@export var spawn_position_x: float = 1100.0

## Y position where portals spawn (ground level)
@export var spawn_position_y: float = 450.0

## Reference to the color wheel for getting random colors
@export var color_wheel: ColorWheel

## Current spawn timer
var spawn_timer: float = 0.0

## Is spawning active?
var is_spawning: bool = true

## Portals spawned count (for statistics)
var portals_spawned: int = 0

func _ready() -> void:
	# Set initial spawn timer
	reset_spawn_timer()

	print("[PortalSpawner] Ready!")
	print("[PortalSpawner] Spawn interval: ", min_spawn_time, "-", max_spawn_time, " seconds")

func _process(delta: float) -> void:
	if not is_spawning:
		return

	# Count down spawn timer
	spawn_timer -= delta

	# Spawn portal when timer reaches zero
	if spawn_timer <= 0.0:
		spawn_portal()
		reset_spawn_timer()

## Spawn a new portal at the right edge of screen
func spawn_portal() -> void:
	if not portal_scene:
		push_error("[PortalSpawner] No portal scene assigned!")
		return

	if not color_wheel:
		push_error("[PortalSpawner] No color wheel reference!")
		return

	# Create portal instance
	var portal: Portal = portal_scene.instantiate()

	# Set portal position
	portal.position = Vector2(spawn_position_x, spawn_position_y)

	# Get random color from wheel
	var random_color: String = color_wheel.get_random_color()

	# Initialize portal with the color
	portal.initialize(random_color)

	# Connect signals
	portal.portal_passed_correct.connect(_on_portal_correct)
	portal.portal_passed_wrong.connect(_on_portal_wrong)

	# Add to scene
	add_child(portal)

	portals_spawned += 1
	print("[PortalSpawner] Spawned portal #", portals_spawned, " - Color: ", random_color)

## Reset the spawn timer to a random value
func reset_spawn_timer() -> void:
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

## Increase spawning difficulty (spawn faster)
func increase_difficulty() -> void:
	# Reduce spawn times by 10%
	min_spawn_time = max(2.0, min_spawn_time * 0.9)
	max_spawn_time = max(3.0, max_spawn_time * 0.9)

	print("[PortalSpawner] Difficulty increased! New interval: ", min_spawn_time, "-", max_spawn_time)

## Start spawning portals
func start_spawning() -> void:
	is_spawning = true
	reset_spawn_timer()
	print("[PortalSpawner] Spawning started")

## Stop spawning portals
func stop_spawning() -> void:
	is_spawning = false
	print("[PortalSpawner] Spawning stopped")

## Clear all active portals
func clear_all_portals() -> void:
	for child in get_children():
		if child is Portal:
			child.queue_free()

	print("[PortalSpawner] All portals cleared")

## Called when a portal is passed correctly
func _on_portal_correct() -> void:
	print("[PortalSpawner] Portal passed correctly!")

## Called when a portal is passed wrong
func _on_portal_wrong() -> void:
	print("[PortalSpawner] Portal passed incorrectly!")
