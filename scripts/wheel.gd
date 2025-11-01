extends Node2D
## Wheel - The spinning color wheel with animal segments
##
## Features:
## - 8 colored segments representing different animals
## - Rotates left/right based on player input
## - Visual indicator for currently selected segment
## - Touch buttons for mobile support

# Wheel configuration
const SEGMENT_COUNT = 8
const WHEEL_RADIUS = 100.0
const ROTATION_SPEED = 3.0  # Radians per second
const SEGMENT_ANGLE = TAU / SEGMENT_COUNT  # TAU = 2*PI = 360 degrees

# Animal colors and names
var animals = [
	{"name": "Bird", "color": Color(0.2, 0.6, 1.0)},      # Blue
	{"name": "Cat", "color": Color(1.0, 0.6, 0.2)},       # Orange
	{"name": "Frog", "color": Color(0.3, 0.9, 0.3)},      # Green
	{"name": "Fish", "color": Color(0.0, 0.8, 0.8)},      # Cyan
	{"name": "Rabbit", "color": Color(0.9, 0.5, 0.8)},    # Pink
	{"name": "Dog", "color": Color(0.7, 0.4, 0.2)},       # Brown
	{"name": "Butterfly", "color": Color(0.8, 0.2, 0.9)}, # Purple
	{"name": "Turtle", "color": Color(0.5, 0.7, 0.3)}     # Yellow-green
]

# Current rotation (in radians)
var current_rotation: float = 0.0
var target_rotation: float = 0.0
var is_rotating: bool = false

# Currently selected segment index (0 to SEGMENT_COUNT-1)
var current_segment_index: int = 0

# References to child nodes
@onready var segments_container = $Segments

func _ready():
	# Create the wheel segments
	create_wheel_segments()

	# Connect to game manager
	if GameManager:
		GameManager.game_over.connect(_on_game_over)

	print("Wheel ready with ", SEGMENT_COUNT, " segments")
	print("Starting segment: ", get_current_animal_name())

func _process(delta):
	# Handle rotation input
	handle_input()

	# Smooth rotation animation
	if is_rotating:
		animate_rotation(delta)

## Handle keyboard and touch input
func handle_input():
	if not GameManager or not GameManager.is_playing():
		return

	# Check for rotation input
	if Input.is_action_just_pressed("rotate_left"):
		rotate_wheel(-1)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_wheel(1)

## Rotate the wheel by a number of segments
## @param direction: -1 for left, 1 for right
func rotate_wheel(direction: int):
	if is_rotating:
		return  # Don't allow rotation while already rotating

	# Calculate new segment index
	current_segment_index = (current_segment_index + direction) % SEGMENT_COUNT
	if current_segment_index < 0:
		current_segment_index = SEGMENT_COUNT - 1

	# Set target rotation
	target_rotation = current_rotation + (direction * SEGMENT_ANGLE)
	is_rotating = true

	print("Rotating to segment: ", get_current_animal_name())

## Animate smooth rotation to target
func animate_rotation(delta):
	var rotation_diff = target_rotation - current_rotation

	# Check if we're close enough to target
	if abs(rotation_diff) < 0.01:
		current_rotation = target_rotation
		is_rotating = false
		rotation = current_rotation
		return

	# Smoothly interpolate to target
	current_rotation = lerp(current_rotation, target_rotation, delta * ROTATION_SPEED)
	rotation = current_rotation

## Create the visual wheel segments
func create_wheel_segments():
	# Clear any existing segments
	for child in segments_container.get_children():
		child.queue_free()

	# Create each segment
	for i in range(SEGMENT_COUNT):
		var segment = create_segment(i)
		segments_container.add_child(segment)

## Create a single wheel segment
func create_segment(index: int) -> Node2D:
	var segment = Node2D.new()
	segment.name = "Segment_" + str(index)

	# Create the colored polygon for this segment
	var polygon = Polygon2D.new()

	# Calculate segment vertices (pie slice shape)
	var start_angle = index * SEGMENT_ANGLE
	var end_angle = (index + 1) * SEGMENT_ANGLE
	var vertices = PackedVector2Array()

	# Center point
	vertices.append(Vector2.ZERO)

	# Arc points (create smooth arc with multiple points)
	var arc_resolution = 16
	for j in range(arc_resolution + 1):
		var t = float(j) / arc_resolution
		var angle = lerp(start_angle, end_angle, t)
		var point = Vector2(cos(angle), sin(angle)) * WHEEL_RADIUS
		vertices.append(point)

	polygon.polygon = vertices
	polygon.color = animals[index].color

	# Add white border
	var line = Line2D.new()
	line.width = 2
	line.default_color = Color.WHITE
	for point in vertices:
		line.add_point(point)
	line.add_point(vertices[0])  # Close the shape

	segment.add_child(polygon)
	segment.add_child(line)

	# Add animal name label at the middle of the segment
	var label = Label.new()
	label.text = animals[index].name
	var mid_angle = start_angle + SEGMENT_ANGLE / 2
	label.position = Vector2(cos(mid_angle), sin(mid_angle)) * (WHEEL_RADIUS * 0.6)
	label.position -= Vector2(label.size.x / 2, label.size.y / 2)  # Center the label
	label.add_theme_font_size_override("font_size", 12)
	segment.add_child(label)

	return segment

## Get the currently selected animal name
func get_current_animal_name() -> String:
	return animals[current_segment_index].name

## Get the currently selected animal color
func get_current_animal_color() -> Color:
	return animals[current_segment_index].color

## Get current segment index
func get_current_segment_index() -> int:
	return current_segment_index

## Check if current selection matches a target animal
func matches_animal(animal_name: String) -> bool:
	return get_current_animal_name() == animal_name

## Get random animal name (for portal generation)
func get_random_animal_name() -> String:
	return animals.pick_random().name

## Called when game is over
func _on_game_over():
	is_rotating = false
