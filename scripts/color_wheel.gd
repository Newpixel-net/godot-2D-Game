## Color Wheel controller
##
## Displays a spinning wheel with colored animal segments.
## The wheel rotates continuously and automatically.
## The active segment (top position) determines the current color for matching.
##
## @tutorial: See docs/ASSET_INTEGRATION.md for wheel sprite replacement

extends Control
class_name ColorWheel

## Auto-rotation speed in degrees per second
@export var rotation_speed: float = 30.0

## Radius of the wheel for drawing segments
@export var wheel_radius: float = 75.0

## Available animal segments (color names)
@export var segments: Array[String] = [
	"blue", "red", "green", "yellow",
	"purple", "orange", "pink", "brown"
]

## Current rotation angle in degrees
var current_rotation: float = 0.0

## Index of currently active segment (at top position - 270 degrees)
var current_segment_index: int = 0

## Previous segment index (for detecting changes)
var previous_segment_index: int = -1

## Reference to visual nodes
@onready var wheel_sprite: Node2D = $WheelSprite
@onready var segments_container: Node2D = $WheelSprite/Segments
@onready var indicator: Polygon2D = $ActiveIndicator

## Emitted when the active segment changes
signal segment_changed(color: String)

## Map of segment names to colors
var segment_colors: Dictionary = {
	"blue": Color(0.2, 0.6, 1.0),
	"red": Color(1.0, 0.2, 0.2),
	"green": Color(0.2, 1.0, 0.2),
	"yellow": Color(1.0, 1.0, 0.2),
	"purple": Color(0.8, 0.2, 1.0),
	"orange": Color(1.0, 0.6, 0.2),
	"pink": Color(1.0, 0.4, 0.8),
	"brown": Color(0.6, 0.4, 0.2)
}

func _ready() -> void:
	# Create the wheel visual
	create_wheel_segments()

	# Create the active segment indicator
	create_indicator()

	# Set initial active segment
	update_active_segment()

	print("[ColorWheel] Ready! Starting with: ", get_active_color())
	print("[ColorWheel] Rotation speed: ", rotation_speed, " degrees/second")

func _process(delta: float) -> void:
	# Auto-rotate the wheel continuously
	current_rotation += rotation_speed * delta

	# Keep rotation in 0-360 range
	if current_rotation >= 360.0:
		current_rotation -= 360.0

	# Apply rotation to wheel sprite
	if wheel_sprite:
		wheel_sprite.rotation_degrees = current_rotation

	# Calculate which segment is now active (top position = 270 degrees)
	var segment_angle: float = 360.0 / float(segments.size())

	# The active segment is at top (270 degrees in our coordinate system)
	# We need to calculate which segment is currently at that position
	var adjusted_rotation: float = fmod(current_rotation + 360.0 + (segment_angle / 2.0), 360.0)
	var new_index: int = int(adjusted_rotation / segment_angle) % segments.size()

	# Detect segment change
	if new_index != current_segment_index:
		current_segment_index = new_index
		update_active_segment()

## Create the visual wheel segments
## PLACEHOLDER: Draws segments programmatically. Replace with sprite when asset ready.
func create_wheel_segments() -> void:
	if not segments_container:
		return

	# Clear existing segments
	for child in segments_container.get_children():
		child.queue_free()

	var segment_angle: float = 360.0 / float(segments.size())

	# Create each segment as a pie slice
	for i in range(segments.size()):
		var segment: Node2D = create_segment(i, segment_angle)
		segments_container.add_child(segment)

## Create a single segment pie slice
func create_segment(index: int, segment_angle: float) -> Node2D:
	var segment: Node2D = Node2D.new()
	segment.name = "Segment_" + str(index)

	# Create polygon for the pie slice
	var polygon: Polygon2D = Polygon2D.new()

	var start_angle_deg: float = index * segment_angle
	var end_angle_deg: float = (index + 1) * segment_angle

	var start_angle_rad: float = deg_to_rad(start_angle_deg)
	var end_angle_rad: float = deg_to_rad(end_angle_deg)

	var vertices: PackedVector2Array = PackedVector2Array()

	# Center point
	vertices.append(Vector2.ZERO)

	# Arc points
	var arc_steps: int = 16
	for j in range(arc_steps + 1):
		var t: float = float(j) / float(arc_steps)
		var angle: float = lerp(start_angle_rad, end_angle_rad, t)
		var point: Vector2 = Vector2(cos(angle), sin(angle)) * wheel_radius
		vertices.append(point)

	polygon.polygon = vertices
	polygon.color = segment_colors.get(segments[index], Color.WHITE)

	# Add border
	var border: Line2D = Line2D.new()
	border.width = 2.0
	border.default_color = Color.WHITE
	for vertex in vertices:
		border.add_point(vertex)
	border.add_point(vertices[0])  # Close the loop

	segment.add_child(polygon)
	segment.add_child(border)

	# Add label
	var label: Label = Label.new()
	label.text = segments[index].capitalize()
	label.add_theme_font_size_override("font_size", 10)

	# Position label at middle of segment
	var mid_angle: float = deg_to_rad(start_angle_deg + segment_angle / 2.0)
	label.position = Vector2(cos(mid_angle), sin(mid_angle)) * (wheel_radius * 0.6)
	label.position -= label.size / 2.0  # Center the label

	segment.add_child(label)

	return segment

## Create the active segment indicator (arrow pointing to top)
func create_indicator() -> void:
	if not indicator:
		return

	# Create triangle pointing down at the active segment (top of wheel)
	var triangle: PackedVector2Array = PackedVector2Array()
	triangle.append(Vector2(0, -wheel_radius - 20))  # Top point
	triangle.append(Vector2(-15, -wheel_radius - 5))  # Left point
	triangle.append(Vector2(15, -wheel_radius - 5))   # Right point

	indicator.polygon = triangle
	indicator.color = Color.YELLOW

## Update visual feedback for the currently active segment
func update_active_segment() -> void:
	# Emit signal if segment actually changed
	if current_segment_index != previous_segment_index:
		previous_segment_index = current_segment_index
		segment_changed.emit(get_active_color())
		print("[ColorWheel] Active color: ", get_active_color())

## Get the currently active color name
func get_active_color() -> String:
	if current_segment_index >= 0 and current_segment_index < segments.size():
		return segments[current_segment_index]
	return "blue"  # Default fallback

## Get the Color value of the active segment
func get_active_color_value() -> Color:
	return segment_colors.get(get_active_color(), Color.WHITE)

## Get a random color name from the wheel (for portal spawning)
func get_random_color() -> String:
	return segments.pick_random()

## Get all available colors
func get_all_colors() -> Array[String]:
	return segments.duplicate()

## Increase rotation speed (for difficulty progression)
func increase_speed(amount: float) -> void:
	rotation_speed += amount
	print("[ColorWheel] Speed increased to: ", rotation_speed)

## Stop rotation (for game over)
func stop_rotation() -> void:
	rotation_speed = 0.0
