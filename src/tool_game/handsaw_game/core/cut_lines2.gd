# -----------------------------------------------------------------------------
# cut_lines2.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name CutLines2

var _startMarker : CutMarker
var _endMarker : CutMarker
var _visual_line: Line2D

func _ready() -> void:
	_startMarker = CutMarker.new()
	_endMarker = CutMarker.new(Color.BLUE)
	
	_visual_line = Line2D.new()
	_visual_line.width = 3
	_visual_line.default_color = Color.RED
	_visual_line.add_point(_startMarker.position)
	_visual_line.add_point(_endMarker.position)
	
	add_child(_startMarker)
	add_child(_endMarker)
	add_child(_visual_line)

func _process(_delta: float) -> void:
	if _endMarker.visible:
		_visual_line.set_point_position(0, _startMarker.position)
		_visual_line.set_point_position(1, _endMarker.position)

func show_marker(is_first_marker: bool)->void:
	var marker = _startMarker if is_first_marker else _endMarker
	marker.show()
	
func hide_marker(is_first_marker: bool) -> void:
	var marker = _startMarker if is_first_marker else _endMarker
	marker.hide()

func move_marker(is_first_marker : bool, direction: Vector2) -> void:
	var marker = _startMarker if is_first_marker else _endMarker
	marker.set_direction(direction.y)
	
func start_new_cut() -> void :
	_startMarker.show()
	_endMarker.hide()
	_visual_line.hide()

func get_cutline_angle() -> float: # todo check usage... can remove ?
	return ((_startMarker.position - _endMarker.position).angle_to(Vector2(0,1)) +3.141593 )* -1

func to_line2D() -> Line2D:
	var result = Line2D.new()
	result.width = 3
	result.default_color = Color.BLACK
	result.add_point(_startMarker.position)
	result.add_point(_endMarker.position)
	return result

func on_wood_geometry_changed(new_shape: PackedVector2Array)-> void:
	var segments = Segment.from_polygon(new_shape)
	_startMarker.set_path(segments)
	_endMarker.set_path(segments)
	start_new_cut()
	
func show_line(yes: bool) -> void:
	#TODO need to harmonize logic with hide_marker(bool) and show_marker(bool) in order to have a single logic
	if yes:
		_visual_line.show()
	else:
		_visual_line.hide()
