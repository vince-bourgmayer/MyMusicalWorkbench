# -----------------------------------------------------------------------------
# CutStartMarker.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Marker2D
class_name CutMarker

const MOVEMENT_SPEED = 1
var path_segments : Array[Segment] = [] # Segment that define the path for the marker. 
var current_segment_index := 0 
var relative_position := 0.0 # used for lerp, it's the position on the current segment

var direction = 0 # -1 backward, 0 idle, +1 forward
var color:Color = Color.RED

func _init(_color:Color = Color.RED) -> void:
	color = _color
	pass
	
func _process(delta: float) -> void:
	move_along_path(delta)
	
func set_path(segments: Array[Segment]) -> void:
	path_segments = segments
	update_position()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, color)

# --- DÉPLACEMENT ---
func move_along_path(delta: float):
	relative_position += direction * MOVEMENT_SPEED * delta

	while relative_position > 1.0:
		move_to_next_segment()
		relative_position -= 1.0 # Don't reset to 0 to avoid raw change

	while relative_position < 0.0:
		move_to_previous_segment()
		relative_position += 1.0
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
	
	position = start.lerp(end, relative_position)
	
func set_direction(p_direction: int):
	direction = p_direction

func split_current_segment(): # split the current segment at this marker position
	relative_position = 1.0

	#print("[Before split] current index:", current_segment_index, ": ", path_segments[current_segment_index].start, ";", path_segments[current_segment_index].end)
	#dump_segments()
	#1 on créé deux segment à partir des 3 points
	var second_Half = path_segments[current_segment_index].duplicate()
	second_Half.start = position
	
	path_segments[current_segment_index].end = position 
	path_segments.insert(current_segment_index+1, second_Half)
	update_position()
	
	#print("[After split] current index:", current_segment_index, ": ", path_segments[current_segment_index].start, ";", path_segments[current_segment_index].end)
	#dump_segments()


func dump_segments():
	print("=====Dumping segments=====\n[")
	for i in path_segments:
		print("		(", i.start, ";", i.end, ")," )
	print("]\n\n")
