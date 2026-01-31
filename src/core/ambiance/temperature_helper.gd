# -----------------------------------------------------------------------------
# temperature_helper.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name TemperatureHelper

const MAX_DAY = 365.0
const MAX_HOUR = 24.0

# TODO extract in a regional data structure
var seasonal_offset := -0.56 #will varie depending on area/country but later.
var regional_base := 11.0 # the medium temperature value for the given area
var annual_amplitude_warm := 18.0 # max above mean (summer)
var annual_amplitude_cold := 12.0  # max below mean (winter)
var daily_offset := -0.625
var daily_amplitude_warm := 3.5
var daily_amplitude_cold := 2.0

# normalized in [-1 ; 1]
func _get_seasonal_factor(day: int) -> float:
	var year_progress = float(day) / MAX_DAY
	return cos(TAU * (year_progress + seasonal_offset))
	
func _get_seasonal_variation(seasonal_factor: float):
	var result : float
	if seasonal_factor >= 0:
		result = annual_amplitude_warm * seasonal_factor
	else:
		result = daily_amplitude_cold * seasonal_factor
	return result

func get_base_temp_for_day(day: int) -> float:
	var seasonal_factor = _get_seasonal_factor(day)
	var variation = _get_seasonal_variation(seasonal_factor)
	
	return regional_base + variation
	
# normalized in [-1 ; 1]
func _get_daily_factor(hour: int) -> float:
	var day_progress = float(hour) / MAX_HOUR
	return cos(TAU * (day_progress + daily_offset))
	
func _get_daily_variation(daily_factor: float):
	var result : float
	if daily_factor >= 0:
		result = daily_amplitude_warm * daily_factor
	else:
		result = daily_amplitude_cold * daily_factor
	return result
	
func get_base_temp_for_datetime(day: int, hour: int) -> float:
	var base_temp = get_base_temp_for_day(day)
	var daily_factor = _get_daily_factor(hour)
	var variation = _get_daily_variation(daily_factor)
	
	return base_temp + variation
	
func get_daily_noise(day: int) -> float:
	var random_generator := RandomNumberGenerator.new()
	random_generator.seed = day
	return random_generator.randf_range(-0.75, 1.25)
