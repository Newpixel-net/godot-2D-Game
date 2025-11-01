## Game Scene Controller
##
## Main game controller that coordinates all game systems:
## - Player, Color Wheel, Portal Spawning
## - Score and wrong answer tracking
## - Game state management (playing, paused, game over)
## - Difficulty progression
## - Background scrolling
##
## This is the central hub that connects all game components together.

extends Node2D
class_name GameScene

## References to game components
@onready var player: Player = $Player
@onready var color_wheel: ColorWheel = $UILayer/ColorWheel
@onready var portal_spawner: PortalSpawner = $PortalSpawner
@onready var game_ui: GameUI = $UILayer
@onready var audio_manager: AudioManager = $AudioManager
@onready var background: ParallaxBackground = $ParallaxBackground

## Game state
enum State { PLAYING, PAUSED, GAME_OVER }
var current_state: State = State.PLAYING

## Score tracking
var score: int = 0
var wrong_count: int = 0
var max_wrong: int = 3

## Difficulty settings
var base_spawn_interval: float = 4.0
var difficulty_increase_interval: int = 5  # Increase difficulty every N points

func _ready() -> void:
	# Initialize game
	setup_connections()
	start_game()

	print("[GameScene] Game started!")
	print("[GameScene] Controls: SPACE to jump, ESC to pause")

func _process(delta: float) -> void:
	# Update background scrolling based on game state
	if current_state == State.PLAYING:
		update_background_scroll(delta)

## Set up signal connections between game components
func setup_connections() -> void:
	# Connect player signals
	if player:
		player.jumped.connect(_on_player_jumped)
		player.color_changed.connect(_on_player_color_changed)

	# Connect color wheel signals
	if color_wheel:
		color_wheel.segment_changed.connect(_on_wheel_segment_changed)

	# Set portal spawner reference to color wheel
	if portal_spawner and color_wheel:
		portal_spawner.color_wheel = color_wheel

	# Connect portal spawner signals (done in spawner when creating portals)
	# Portals connect their own signals to this scene

	# Connect UI signals
	if game_ui:
		game_ui.pause_pressed.connect(_on_pause_pressed)

	print("[GameScene] Signals connected")

## Start a new game
func start_game() -> void:
	current_state = State.PLAYING
	score = 0
	wrong_count = 0

	# Update UI
	if game_ui:
		game_ui.update_score(score)
		game_ui.update_wrong(wrong_count)

	# Start spawning portals
	if portal_spawner:
		portal_spawner.start_spawning()

	# Start background music
	if audio_manager:
		audio_manager.play_music()

	print("[GameScene] Game started - Good luck!")

## Handle player jumping
func _on_player_jumped() -> void:
	# Play jump sound
	if audio_manager:
		audio_manager.play_sfx("jump")

## Handle player color changing
func _on_player_color_changed(new_color: String) -> void:
	print("[GameScene] Player color changed to: ", new_color)

## Handle wheel segment changing
func _on_wheel_segment_changed(color: String) -> void:
	# Optional: Could trigger visual feedback
	pass

## Handle correct portal match
func on_correct_match() -> void:
	if current_state != State.PLAYING:
		return

	# Increase score
	score += 1

	# Update UI
	if game_ui:
		game_ui.update_score(score)

	# Play success sound
	if audio_manager:
		audio_manager.play_sfx("correct")

	# Change player color to match wheel
	if player and color_wheel:
		player.set_color(color_wheel.get_active_color())

	# Check for difficulty increase
	if score % difficulty_increase_interval == 0:
		increase_difficulty()

	print("[GameScene] Correct match! Score: ", score)

## Handle wrong portal match
func on_wrong_match() -> void:
	if current_state != State.PLAYING:
		return

	# Increase wrong count
	wrong_count += 1

	# Update UI
	if game_ui:
		game_ui.update_wrong(wrong_count)

	# Play wrong sound
	if audio_manager:
		audio_manager.play_sfx("wrong")

	# Screen shake effect
	screen_shake()

	# Check for game over
	if wrong_count >= max_wrong:
		trigger_game_over()

	print("[GameScene] Wrong match! Wrong count: ", wrong_count, "/", max_wrong)

## Increase game difficulty
func increase_difficulty() -> void:
	# Increase portal spawn rate
	if portal_spawner:
		portal_spawner.increase_difficulty()

	# Increase wheel rotation speed
	if color_wheel:
		color_wheel.increase_speed(5.0)

	print("[GameScene] Difficulty increased at score: ", score)

## Trigger game over
func trigger_game_over() -> void:
	current_state = State.GAME_OVER

	# Stop game systems
	if portal_spawner:
		portal_spawner.stop_spawning()

	if color_wheel:
		color_wheel.stop_rotation()

	# Play game over sound
	if audio_manager:
		audio_manager.play_sfx("game_over")
		audio_manager.stop_music()

	# Player idle animation
	if player:
		player.play_idle()

	print("[GameScene] GAME OVER! Final Score: ", score)

	# Wait a moment, then load game over scene
	await get_tree().create_timer(2.0).timeout
	load_game_over_scene()

## Load the game over scene
func load_game_over_scene() -> void:
	# Save final score to global/singleton if needed
	# Then load game over scene

	if ResourceLoader.exists("res://scenes/GameOverScreen.tscn"):
		get_tree().change_scene_to_file("res://scenes/GameOverScreen.tscn")
	else:
		# Fallback: restart current scene
		print("[GameScene] Game over scene not found, restarting...")
		restart_game()

## Restart the game
func restart_game() -> void:
	get_tree().reload_current_scene()

## Pause the game
func pause_game() -> void:
	if current_state == State.PLAYING:
		current_state = State.PAUSED
		get_tree().paused = true
		print("[GameScene] Game paused")

## Resume the game
func resume_game() -> void:
	if current_state == State.PAUSED:
		current_state = State.PLAYING
		get_tree().paused = false
		print("[GameScene] Game resumed")

## Toggle pause
func toggle_pause() -> void:
	if current_state == State.PLAYING:
		pause_game()
	elif current_state == State.PAUSED:
		resume_game()

## Handle pause button pressed
func _on_pause_pressed() -> void:
	toggle_pause()

## Handle input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

## Update parallax background scrolling
func update_background_scroll(delta: float) -> void:
	if not background:
		return

	# Scroll background to the left
	var scroll_speed: float = -200.0  # Match portal movement speed
	background.scroll_offset.x += scroll_speed * delta

## Simple screen shake effect
func screen_shake() -> void:
	# Implement screen shake by moving camera slightly
	# For now, just log it
	print("[GameScene] *Screen shake*")

	# TODO: Implement actual camera shake when Camera2D is added
