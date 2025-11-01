## Game UI Controller
##
## Manages all in-game user interface elements:
## - Score display
## - Wrong counter with visual feedback
## - Mobile touch controls
## - Pause button
##
## Does NOT handle game over screen (that's a separate scene)

extends CanvasLayer
class_name GameUI

## References to UI labels
@onready var score_label: Label = $ScoreLabel
@onready var wrong_label: Label = $WrongLabel

## Mobile/touch control buttons
@onready var touch_controls: Control = $TouchControls
@onready var left_button: Button = $TouchControls/LeftButton
@onready var right_button: Button = $TouchControls/RightButton

## Pause/settings button
@onready var pause_button: Button = $PauseButton

## Current score value
var score: int = 0

## Current wrong count
var wrong_count: int = 0

## Maximum wrong answers allowed
var max_wrong: int = 3

## Signals
signal pause_pressed

func _ready() -> void:
	# Connect touch buttons if they exist
	if left_button:
		left_button.pressed.connect(_on_left_button_pressed)

	if right_button:
		right_button.pressed.connect(_on_right_button_pressed)

	# Connect pause button
	if pause_button:
		pause_button.pressed.connect(_on_pause_pressed)

	# Initialize displays
	update_score(0)
	update_wrong(0)

	# Check if on mobile to show/hide touch controls
	setup_touch_controls()

	print("[GameUI] Ready!")

## Setup touch controls visibility
func setup_touch_controls() -> void:
	if not touch_controls:
		return

	# Show touch controls on mobile/web, hide on desktop
	var is_mobile: bool = OS.get_name() in ["Android", "iOS", "Web"]
	touch_controls.visible = is_mobile

	print("[GameUI] Touch controls visible: ", is_mobile)

## Update score display
func update_score(new_score: int) -> void:
	score = new_score

	if score_label:
		score_label.text = "SCORE: " + str(score)

		# Animate score change
		animate_label(score_label)

## Update wrong counter display
func update_wrong(count: int) -> void:
	wrong_count = count

	if wrong_label:
		wrong_label.text = "WRONG: " + str(count) + "/" + str(max_wrong)

		# Change color based on danger level
		update_wrong_color(count)

		# Animate wrong counter
		animate_label(wrong_label)

## Update wrong counter color based on count
func update_wrong_color(count: int) -> void:
	if not wrong_label:
		return

	match count:
		0:
			wrong_label.add_theme_color_override("font_color", Color.WHITE)
		1:
			wrong_label.add_theme_color_override("font_color", Color.YELLOW)
		2:
			wrong_label.add_theme_color_override("font_color", Color.ORANGE)
		_:
			wrong_label.add_theme_color_override("font_color", Color.RED)

## Animate a label with a scale pulse
func animate_label(label: Label) -> void:
	if not label:
		return

	var tween: Tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)

## Get current score
func get_score() -> int:
	return score

## Get current wrong count
func get_wrong_count() -> int:
	return wrong_count

## Handle left button press (for manual wheel rotation if needed)
func _on_left_button_pressed() -> void:
	# Trigger jump input event
	var event: InputEventAction = InputEventAction.new()
	event.action = "jump"
	event.pressed = true
	Input.parse_input_event(event)

	print("[GameUI] Left button pressed (Jump)")

## Handle right button press (for manual wheel rotation if needed)
func _on_right_button_pressed() -> void:
	# Could be used for special abilities in future
	print("[GameUI] Right button pressed")

## Handle pause button press
func _on_pause_pressed() -> void:
	pause_pressed.emit()
	print("[GameUI] Pause pressed")

## Show pause overlay (if implemented)
func show_pause_menu() -> void:
	# Implement pause menu if needed
	pass

## Hide pause overlay
func hide_pause_menu() -> void:
	# Implement pause menu if needed
	pass
