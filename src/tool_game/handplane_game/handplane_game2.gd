# -----------------------------------------------------------------------------
# handplane_game2.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandPlaneGame2

@onready var _jackplane = $JackPlane
@onready var _woodRenderer := $WoodRenderer
@onready var _collision_box := $CollisionBox
@onready var _collision_shape := $WoodRenderer/CollisionBox/CollisionShape

enum gameState { PLACE, PLANE, RESTART}

var _plane_placer: PlanePlacer
var _plane_operation : PlaneOperation
var _plane_pressure := PlanePressure.new()

var _triggerInputReader := TriggersInputReader.new()
var _directionalInputReader := DirectionalInputReader.new()
var _woodPiece : WoodPiece #need to be passed to parent when exiting


func _ready() -> void:
	self.add_child(_triggerInputReader)
	self.add_child(_directionalInputReader)
	
	_woodPiece = WoodPiece.new("Alder", _woodRenderer.get_wood_size())
	_woodRenderer.bind(_woodPiece)
	
	_collision_shape.polygon = _woodPiece.get_geometry_polygon()
	_collision_shape.transform = _woodRenderer.transform

	var startLine = _get_start_line()
	_plane_placer = PlanePlacer.new(startLine)
	
	_triggerInputReader.triggers_pressure_changed.connect(_on_triggers_pressure_changed)
	_directionalInputReader.right_stick_direction_changed.connect(_on_right_stick_direction_changed)
	_directionalInputReader.left_stick_direction_changed.connect(_on_left_stick_direction_changed)

	_jackplane.back_area_exited.connect(_on_stroke_finished)
	_jackplane.blade_area_entered.connect(_on_stroke_started)
	_start_state(gameState.PLACE)
	
func _exit_tree():
	_directionalInputReader.right_stick_direction_changed.disconnect(_on_right_stick_direction_changed)
	_directionalInputReader.left_stick_direction_changed.disconnect(_on_left_stick_direction_changed)
	_triggerInputReader.triggers_pressure_changed.disconnect(_on_triggers_pressure_changed)
	_jackplane.back_area_exited.disconnect(_on_stroke_finished)
	_jackplane.blade_area_entered.disconnect(_on_stroke_started)
	
	_jackplane.queue_free()
	_woodRenderer.queue_free()
	_directionalInputReader.queue_free()
	_triggerInputReader.queue_free()
	
func _process(delta):
	if _current_state == gameState.PLACE:
		_jackplane.position = _plane_placer.update_start_position(delta)

func _exit_state(state: int) -> void:
	match state:
		gameState.PLANE:
			_plane_operation = null
		_: pass

	
func _enter_state(new_state: int) -> void:
	match new_state:
		gameState.PLACE:
			_set_plane_on_start_line(_plane_placer.get_start_position())
		gameState.PLANE:
			var start_position = _plane_placer.get_start_position()
			_plane_operation = PlaneOperation.new(start_position)
			pass
		_: pass
		
func _get_start_line() -> Segment:
	var polygon = _woodPiece.get_geometry_polygon()
	var global_start_point = _woodRenderer.to_global(polygon[2])
	var global_end_point = _woodRenderer.to_global(polygon[3])
	var result := Segment.new(global_start_point, global_end_point)
	return result

func _get_final_state() -> int:
	return gameState.RESTART
	
func _on_game_cancelled() -> void:
	cancel_game("Do you want to stop planing ?", "Press A to validate")

func _set_plane_on_start_line(start_point: Vector2) -> void:
	var tw := create_tween()
	tw.tween_property(_jackplane, "position", start_point, 0.5)
	await tw.finished
	
func _on_left_stick_direction_changed(direction: Vector2) -> void:
	if _current_state == gameState.PLACE:
		_jackplane.set_rotation_input(direction)
	
func _on_right_stick_direction_changed(direction: Vector2) -> void:
	if _current_state == gameState.PLACE:
		_plane_placer.set_direction(int(direction.x))

func _on_triggers_pressure_changed(right_trigger_pressure: float, left_trigger_pressure: float) -> void:
	if _current_state == gameState.PLANE:
		_plane_pressure.set_hands_pressure(right_trigger_pressure, left_trigger_pressure)
		if _plane_pressure.is_enough_pressure():
			var total_pressure = _plane_pressure.get_total_pressure()
			var pressures_balance = _plane_pressure.get_pressures_balance_factor()
			_jackplane.update_relative_speed(total_pressure, pressures_balance)
			_jackplane.push(true)
		else:
			_jackplane.update_relative_speed(0.0, 0.0)
			_jackplane.push(false)

func _on_stroke_finished() -> void:
	_change_state(gameState.PLACE)
	
func _on_stroke_started() -> void:
	pass
