# -----------------------------------------------------------------------------
# triggers_input_reader.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name TriggersInputReader

var _left_trigger_pressure := 0.0
var _right_trigger_pressure := 0.0

signal left_trigger_pressure_changed(pressure: float)
signal right_trigger_pressure_changed(pressure: float)

func _process(_delta: float) -> void:
	_read_left_trigger_pressure()
	_read_right_trigger_pressure()

func _read_left_trigger_pressure():
	var newLeftTriggerPressure = Input.get_action_strength("trigger_left")
	if (newLeftTriggerPressure != _left_trigger_pressure):
		_left_trigger_pressure = newLeftTriggerPressure
		left_trigger_pressure_changed.emit(_left_trigger_pressure)

func _read_right_trigger_pressure():
	var newRightTriggerPressure = Input.get_action_strength("trigger_right")

	if (newRightTriggerPressure != _right_trigger_pressure):
		_right_trigger_pressure = newRightTriggerPressure
		right_trigger_pressure_changed.emit(_right_trigger_pressure)
