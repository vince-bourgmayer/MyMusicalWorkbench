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
@export var ingame_minutes_per_tick := 240#1.0

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

	_signals_emit_on_tick(_get_current_ingame_time())

func _on_tick() -> void:
	_ingame_elapsed_minutes += ingame_minutes_per_tick
	
	var datetime = _get_current_ingame_time()
	_signals_emit_on_tick(datetime)
	

func _signals_emit_on_tick(datetime: Dictionary):
	_emit_time_changed(datetime)
	
	if datetime.get("minute", 1) == 0:
		hour_changed.emit(datetime.get("hour", 12))
		if datetime.get("hour", 1) % 24 == 0:
			day_changed.emit(datetime.get("day_in_year", -1))
	
	
func _emit_time_changed(datetime: Dictionary) -> void:
	time_changed.emit(datetime)
	
@warning_ignore("integer_division")
func _get_current_ingame_time() -> Dictionary:
	var total_minutes := _ingame_elapsed_minutes

	var minute := total_minutes % 60
	var total_hours := total_minutes / 60

	var hour := total_hours % 24
	var total_days := total_hours / 24

	var day := total_days % 30 + 1
	var total_months := total_days / 30

	var month := total_months % 12 + 1
	var year := total_months / 12

	var day_in_year = int(_ingame_elapsed_minutes / 1440)
	
	return {
		"year": year,
		"month": month,
		"day": day,
		"hour": hour,
		"minute": minute,
		"day_in_year": day_in_year
	}
 
