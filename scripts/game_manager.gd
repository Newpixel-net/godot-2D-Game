extends Node
## GameManager - Handles global game state, scoring, and game flow
##
## This singleton manages:
## - Current game state (playing, paused, game over)
## - Score tracking
## - Wrong answer counter
## - Game speed progression

# Game states
enum GameState {
	PLAYING,
	PAUSED,
	GAME_OVER
}

# Game configuration
const MAX_WRONG_ANSWERS = 3
const INITIAL_SPEED = 200.0
const SPEED_INCREASE_PER_POINT = 10.0
const MAX_SPEED = 500.0

# Current game state
var current_state: GameState = GameState.PLAYING
var score: int = 0
var wrong_count: int = 0
var game_speed: float = INITIAL_SPEED

# Signals to notify other parts of the game
signal score_changed(new_score: int)
signal wrong_count_changed(new_count: int)
signal game_over
signal game_speed_changed(new_speed: float)
signal correct_match
signal wrong_match

func _ready():
	# Initialize the game when it starts
	reset_game()

## Reset all game variables to their initial state
func reset_game():
	current_state = GameState.PLAYING
	score = 0
	wrong_count = 0
	game_speed = INITIAL_SPEED

	# Emit initial values
	score_changed.emit(score)
	wrong_count_changed.emit(wrong_count)
	game_speed_changed.emit(game_speed)

## Called when player matches portal correctly
func add_score():
	if current_state != GameState.PLAYING:
		return

	score += 1
	score_changed.emit(score)
	correct_match.emit()

	# Increase game speed progressively
	game_speed = min(game_speed + SPEED_INCREASE_PER_POINT, MAX_SPEED)
	game_speed_changed.emit(game_speed)

	print("Score: ", score, " | Speed: ", game_speed)

## Called when player gets wrong match
func add_wrong():
	if current_state != GameState.PLAYING:
		return

	wrong_count += 1
	wrong_count_changed.emit(wrong_count)
	wrong_match.emit()

	print("Wrong count: ", wrong_count, "/", MAX_WRONG_ANSWERS)

	# Check if game over
	if wrong_count >= MAX_WRONG_ANSWERS:
		end_game()

## End the game
func end_game():
	current_state = GameState.GAME_OVER
	game_over.emit()
	print("Game Over! Final Score: ", score)

## Pause the game
func pause_game():
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true

## Resume the game
func resume_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false

## Check if game is currently playing
func is_playing() -> bool:
	return current_state == GameState.PLAYING
