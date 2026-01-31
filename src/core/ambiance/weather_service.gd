# -----------------------------------------------------------------------------
# weather_service.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name WeatherService

signal weather_changed(temperature: float, humidity: float)

var temperatureHelper: TemperatureHelper
var currentDay : int
var temperature: float
var humidity : float
var daily_random_temp_modifier : float

func _ready() -> void:
	temperatureHelper = TemperatureHelper.new()
	humidity = 43.0

func on_new_day(day_in_year: int) -> void:
	currentDay = day_in_year
	daily_random_temp_modifier = temperatureHelper.get_daily_noise(currentDay)
	
func on_new_hour(hour: int) -> void:
	temperature = temperatureHelper.get_base_temp_for_datetime(currentDay, hour) + daily_random_temp_modifier
	weather_changed.emit(temperature, humidity)
