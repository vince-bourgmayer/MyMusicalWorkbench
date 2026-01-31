# -----------------------------------------------------------------------------
# humidity _helper.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name HumidityHelper

const MAX_DAY = 365.0

# TODO extract in a regional data structure
var seasonal_offset := -0.56 #will varie depending on area/country but later.
var regional_base := 70.0 # the medium humidity for the given area
var annual_amplitude_humid := 13.0
var annual_amplitude_dry := 15.0 


# normalized in [-1 ; 1]
func _get_seasonal_factor(day: int) -> float:
	var year_progress = float(day) / MAX_DAY
	return -cos(TAU * (year_progress + seasonal_offset))
	
func _get_seasonal_variation(seasonal_factor: float):
	var result : float
	if seasonal_factor >= 0:
		result = annual_amplitude_humid * seasonal_factor
	else:
		result = annual_amplitude_dry * seasonal_factor
	return result

func get_base_humidity_for_day(day: int) -> float:
	var seasonal_factor = _get_seasonal_factor(day)
	var variation = _get_seasonal_variation(seasonal_factor)
	
	return regional_base + variation
	
func get_humidity_for_day(day: int) -> float:
	return clamp(get_base_humidity_for_day(day) + _get_daily_noise(day), 0.0, 100.0)
	
func _get_daily_noise(day: int) -> float:
	var random_generator := RandomNumberGenerator.new()
	random_generator.seed = day
	return random_generator.randf_range(-2, 2)
