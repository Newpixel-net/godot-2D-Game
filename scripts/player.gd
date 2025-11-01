extends CharacterBody2D
## Player - The cat character that runs automatically
##
## The player:
## - Moves automatically from left to right
## - Speed is controlled by GameManager
## - Has simple bounce/idle animation (optional)
## - Collision detection happens in the portal script

# Player visual settings
const PLAYER_SIZE = Vector2(60, 60)
const PLAYER_COLOR = Color(1.0, 0.6, 0.2)  # Orange color for cat

# Movement
var current_speed: float = 200.0

# References
@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D

func _ready():
	# Connect to game manager signals
	if GameManager:
		GameManager.game_speed_changed.connect(_on_speed_changed)
		GameManager.game_over.connect(_on_game_over)
		current_speed = GameManager.game_speed

	# Set up the player visual (will be created in scene)
	setup_visuals()

	print("Player ready! Starting speed: ", current_speed)

func _physics_process(delta):
	# Only move if game is playing
	if not GameManager or not GameManager.is_playing():
		velocity = Vector2.ZERO
	else:
		# Move right automatically at current game speed
		velocity.x = current_speed
		velocity.y = 0  # No vertical movement

	# Apply the movement
	move_and_slide()

## Set up player visuals (called from _ready)
func setup_visuals():
	# The sprite and collision will be set up in the scene file
	# This function can be used to adjust them if needed
	pass

## Called when game speed changes
func _on_speed_changed(new_speed: float):
	current_speed = new_speed
	print("Player speed updated: ", new_speed)

## Called when game is over
func _on_game_over():
	# Stop moving
	velocity = Vector2.ZERO
	print("Player stopped - Game Over")

## Get the player's current position for camera following
func get_player_position() -> Vector2:
	return global_position
