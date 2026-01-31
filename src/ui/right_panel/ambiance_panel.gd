extends Control
class_name AmbiancePanel

const WEEKDAYS = ["Mon", "Tues", "Wed","Thurs", "Fri", "Sat", "Sun" ]
const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "December"]
@onready var timeLabel = $ColorRect/VBoxContainer/OthersContainer/Time
@onready var dateLabel = $ColorRect/VBoxContainer/DateContainer/Title
@onready var temperatureLabel = $ColorRect/VBoxContainer/OthersContainer/Temperature
@onready var humidityLabel = $ColorRect/VBoxContainer/OthersContainer/Humidity

func _ready() -> void:
	pass 


func on_time_changed(time: Dictionary) -> void:
	var hour = time.get("hour", "-1")
	var minute = time.get("minute", -1)
	var text := "%02d:%02d" % [hour, minute]
	timeLabel.text = text
	
	var day = time.get("day", 1)
	var month = time.get("month", 1)
	
	dateLabel.text = get_date(day, month)

func on_weather_changed(temperature: float, humidity: float) -> void:
	var temp_text := "%02d°c" % temperature
	temperatureLabel.text = temp_text
	
	var humidity_text := "%02d%%" % humidity
	humidityLabel.text = humidity_text

func get_date(day: int, month: int) -> String:
	return "%s, %s %d%s" % [
		WEEKDAYS[day%7],
		MONTHS[month - 1],
		day,
		ordinal_suffix(day)]


func ordinal_suffix(day: int) -> String:
	match day % 100:
		11, 12, 13: 
			return "th"
	
	match day % 10:
		1:
			return "st"
		2:
			return "nd"
		3:
			return "rd"
		_:
			return "th"
