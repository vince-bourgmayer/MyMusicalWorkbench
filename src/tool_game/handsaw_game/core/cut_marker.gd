# -----------------------------------------------------------------------------
# CutStartMarker.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Marker2D
class_name CutMarker

var path_segments : Array[Segment] = [] # Segment that define the path for the marker. 
var current_segment_index := 0 

var MOVEMENT_SPEED = 250
var relative_position := 0.0 # used for lerp, it's the position on the current segment
var direction = 0 # -1 backward, 0 idle, +1 forward

var color:Color = Color.RED

func _init(_color:Color = Color.RED) -> void:
	color = _color
	direction = 0
	set_process(false)
	
func _process(delta: float) -> void:
	if path_segments != null && path_segments.size() > 0:
		move_along_path(delta)
	
func set_path(segments: Array[Segment]) -> void:
	current_segment_index = 0
	path_segments = segments
	update_position()
	if !is_processing():
		set_process(true)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, color)

# --- DÉPLACEMENT ---
func move_along_path(delta: float):
	var distance_per_frame = (MOVEMENT_SPEED * delta) / path_segments[current_segment_index].get_length()
	relative_position += direction * distance_per_frame

	while relative_position > 1.0:
		move_to_next_segment()
		relative_position -= 1.0 # Don't reset to 0 to avoid raw change
	while relative_position < 0.0:
		move_to_previous_segment()
		relative_position += 1.0
		
	if relative_position != 0:
		update_position()
	
func move_to_next_segment():
	current_segment_index = (current_segment_index + 1) % path_segments.size()
	
func move_to_previous_segment():
	current_segment_index = (current_segment_index - 1 + path_segments.size()) % path_segments.size()
	
func update_position() -> void:
	if path_segments.size() == 0:
		return
		
	var segment = path_segments[current_segment_index]
	var start = segment.start
	var end = segment.end
	
	position = start.lerp(end, relative_position) # issue: smaller segment takes longer to go through

func set_direction(p_direction: int):
	direction = p_direction

func split_current_segment() -> void: # split the current segment at this marker position
	relative_position = 1.0

	#1 on créé deux segment à partir des 3 points
	var second_Half = path_segments[current_segment_index].duplicate()
	second_Half.start = position
	
	path_segments[current_segment_index].end = position 
	path_segments.insert(current_segment_index+1, second_Half)

	update_position()
