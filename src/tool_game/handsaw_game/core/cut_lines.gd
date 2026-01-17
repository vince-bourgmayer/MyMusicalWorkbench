# -----------------------------------------------------------------------------
# cut_lines.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name CutLines

var startMarker : CutMarker
var endMarker : CutMarker
var current_cutLine: Line2D
var wood_edges : Array[Segment]

func _ready() -> void:
	startMarker = CutMarker.new()
	endMarker = CutMarker.new(Color.BLUE)
	
	current_cutLine = Line2D.new()
	current_cutLine.width = 3
	current_cutLine.default_color = Color.RED
	current_cutLine.add_point(startMarker.position)
	current_cutLine.add_point(endMarker.position)
	
	add_child(startMarker)
	add_child(endMarker)
	add_child(current_cutLine)

func _process(_delta: float) -> void:
	if endMarker.visible:
		current_cutLine.set_point_position(0, startMarker.position)
		current_cutLine.set_point_position(1, endMarker.position)
		
func _on_start_point_confirmed() -> void:
	startMarker.split_current_segment()
	wood_edges = startMarker.path_segments
	endMarker.set_path(wood_edges.duplicate())
	endMarker.current_segment_index = startMarker.current_segment_index
	
	endMarker.visible = true
	current_cutLine.visible = true
	
func _on_end_point_confirmed() -> void:
	endMarker.split_current_segment()
	startMarker.visible = false
	endMarker.visible = false
	
func _on_start_point_reverted() -> void:
	endMarker.visible = false
	startMarker.visible = true
	current_cutLine.visible = false

func _on_cut_achieved() -> void:
	var achieved_cut = get_cutline_copy()
	self.add_child(achieved_cut)

func handle_inputs_for_marker(event: InputEvent, is_start_marker: bool):
	var marker = startMarker if is_start_marker else endMarker
	
	if event.is_action_pressed("ui_up"):
		marker.set_direction(-1)
	elif event.is_action_pressed("ui_down"):
		marker.set_direction(1)
	elif event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_cancel") || event.is_action_released("ui_accept"):
		marker.set_direction(0)
	
func start_new_cut(p_wood_edges: Array[Segment]) -> void :
	wood_edges = p_wood_edges
	reset_markers()
	current_cutLine.visible = false

func reset_markers() -> void:
	startMarker.set_direction(0)
	startMarker.set_path(wood_edges)
	startMarker.visible = true
	endMarker.set_direction(0)
	endMarker.visible = false	

func get_cutline_angle() -> float:
	return ((startMarker.position - endMarker.position).angle_to(Vector2(0,1)) +3.141593 )* -1

func get_cutline_copy() -> Line2D:
	var result = Line2D.new()
	result.width = 3
	result.default_color = Color.BLACK
	result.add_point(startMarker.position)
	result.add_point(endMarker.position)
	return result

func get_cut_start_position() -> Vector2:
	return startMarker.global_position

func get_cut_end_position() -> Vector2:
	return endMarker.global_position
