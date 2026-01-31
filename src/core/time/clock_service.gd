# -----------------------------------------------------------------------------
# clock_service.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name ClockService

signal time_changed(current_datetime: Dictionary)
signal day_changed(day: int)
signal hour_changed(hour: int)

# --- Config ---
@export var real_seconds_per_tick := 1.0
@export var ingame_minutes_per_tick := 45

# --- State ---
var _ingame_elapsed_minutes: int = 0
var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = real_seconds_per_tick
	_timer.timeout.connect(_on_tick)
	add_child(_timer)
	_timer.start()

	_signals_emit_on_tick()
	
func _on_tick() -> void:
	_ingame_elapsed_minutes += ingame_minutes_per_tick
	_signals_emit_on_tick()

func _signals_emit_on_tick():
	var datetime = _get_current_ingame_time()
	time_changed.emit(datetime)
	
	var minutes = datetime.get("minute", 1)
	var hours = datetime.get("hour", 1)
	
	if minutes == 0:
		if hours % 24 == 0:
			day_changed.emit(datetime.get("day_in_year", 0)) # must be emitted before hour_changed
		hour_changed.emit(hours)

@warning_ignore("integer_division")
func _get_current_ingame_time() -> Dictionary:
	var total_minutes := _ingame_elapsed_minutes

	var minutes := total_minutes % 60
	var total_hours = int(total_minutes / 60)

	var hours = total_hours % 24
	var total_days = int(total_hours / 24)

	var day_in_month = total_days % 30 + 1
	var total_months = int(total_days / 30)

	var month = clamp(total_months % 12 + 1, 1, 12)
	var years = int(total_months / 12)

	var day_in_year = clamp(int(_ingame_elapsed_minutes / 1440), 0, 365)
	
	return {
		"year": years,
		"month": month,
		"day": day_in_month,
		"hour": hours,
		"minute": minutes,
		"day_in_year": day_in_year
	}
 
