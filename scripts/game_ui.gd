extends CanvasLayer
## GameUI - User interface for score, wrong counter, and game over screen
##
## Displays:
## - Current score
## - Wrong answer counter
## - Game over screen with restart option
## - Touch buttons for mobile/browser

# References to UI elements
@onready var score_label = $ScoreLabel
@onready var wrong_label = $WrongLabel
@onready var game_over_panel = $GameOverPanel
@onready var final_score_label = $GameOverPanel/FinalScoreLabel
@onready var restart_button = $GameOverPanel/RestartButton

# Touch buttons (for mobile/browser)
@onready var rotate_left_button = $TouchControls/RotateLeftButton
@onready var rotate_right_button = $TouchControls/RotateRightButton

func _ready():
	# Connect to GameManager signals
	if GameManager:
		GameManager.score_changed.connect(_on_score_changed)
		GameManager.wrong_count_changed.connect(_on_wrong_count_changed)
		GameManager.game_over.connect(_on_game_over)

	# Hide game over panel initially
	if game_over_panel:
		game_over_panel.visible = false

	# Connect restart button
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)

	# Connect touch buttons
	if rotate_left_button:
		rotate_left_button.pressed.connect(_on_rotate_left_pressed)
	if rotate_right_button:
		rotate_right_button.pressed.connect(_on_rotate_right_pressed)

	# Initialize labels
	update_score_display(0)
	update_wrong_display(0)

	print("UI ready!")

## Update score display
func _on_score_changed(new_score: int):
	update_score_display(new_score)

## Update wrong counter display
func _on_wrong_count_changed(new_count: int):
	update_wrong_display(new_count)

## Update the score label
func update_score_display(score: int):
	if score_label:
		score_label.text = "Score: " + str(score)

## Update the wrong counter label
func update_wrong_display(wrong_count: int):
	if wrong_label:
		var max_wrong = GameManager.MAX_WRONG_ANSWERS if GameManager else 3
		wrong_label.text = "Wrong: " + str(wrong_count) + "/" + str(max_wrong)

		# Change color based on how close to game over
		if wrong_count == 0:
			wrong_label.add_theme_color_override("font_color", Color.WHITE)
		elif wrong_count == 1:
			wrong_label.add_theme_color_override("font_color", Color.YELLOW)
		elif wrong_count == 2:
			wrong_label.add_theme_color_override("font_color", Color.ORANGE)
		else:
			wrong_label.add_theme_color_override("font_color", Color.RED)

## Show game over screen
func _on_game_over():
	if game_over_panel and final_score_label:
		var final_score = GameManager.score if GameManager else 0
		final_score_label.text = "Final Score: " + str(final_score)
		game_over_panel.visible = true

	print("Game Over screen shown")

## Restart button pressed
func _on_restart_pressed():
	print("Restart button pressed")

	# Hide game over panel
	if game_over_panel:
		game_over_panel.visible = false

	# Restart the game
	get_tree().reload_current_scene()

## Touch button - Rotate Left
func _on_rotate_left_pressed():
	# Simulate left arrow key press
	var event = InputEventAction.new()
	event.action = "rotate_left"
	event.pressed = true
	Input.parse_input_event(event)

## Touch button - Rotate Right
func _on_rotate_right_pressed():
	# Simulate right arrow key press
	var event = InputEventAction.new()
	event.action = "rotate_right"
	event.pressed = true
	Input.parse_input_event(event)
