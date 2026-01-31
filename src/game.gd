# -----------------------------------------------------------------------------
# game.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

@onready var workshopGame = $WorkshopGame
@onready var rightPanel = $UI/RightPanel
@onready var ambiancePanel = $UI/RightPanel/AmbiancePanel

var clockService: ClockService
var weatherService : WeatherService

func _ready() -> void:
	weatherService = WeatherService.new()
	weatherService.weather_changed.connect(ambiancePanel.on_weather_changed)
	add_child(weatherService)
	
	clockService = ClockService.new()
	clockService.time_changed.connect(ambiancePanel.on_time_changed)
	clockService.day_changed.connect(weatherService.on_new_day)
	clockService.hour_changed.connect(weatherService.on_new_hour)
	add_child(clockService)
	
	pause_tool_game()
	Signals.switch_game_mode.emit(Globals.game_mode.WORKSHOP)
	workshopGame.popup_requested.connect(_on_popup_requested)
	$UI/Popup._popup_closed.connect(_on_popup_closed)
	showPopup()

func _on_popup_requested(text1:String, text2:String, code: int):
	$UI/Popup.setCode(code)
	$UI/Popup.updateText(text1, text2)
	showPopup()

func showPopup():
	$UI/Popup.show()

func _on_popup_closed(code: int):
	$UI/Popup.hide()
	if code == Globals.game_mode.HANDSAW || code == Globals.game_mode.HANDPLANE:
		pause_workshop_game()
		start_tool_game(code)
	elif code == Globals.game_mode.WORKSHOP:
		pause_tool_game()
		start_workshop_game()

func start_workshop_game():
	Signals.switch_game_mode.emit(Globals.game_mode.WORKSHOP)
	$WorkshopGame.set_process(true)
	$WorkshopGame.set_visible(true)
	$WorkshopGame.popup_requested.connect(_on_popup_requested)

func pause_workshop_game():
	$WorkshopGame.set_process(false)
	$WorkshopGame.set_visible(false)
	if $WorkshopGame.is_connected("popup_requested", _on_popup_requested):
		$WorkshopGame.disconnect("popup_requested", _on_popup_requested)

func start_tool_game(code):
	Signals.switch_game_mode.emit(code)
	$ToolGameSlot.open_game(code)
	$ToolGameSlot.set_visible(true)
	$ToolGameSlot.set_process(true)
	$ToolGameSlot.popup_requested.connect(_on_popup_requested)

func pause_tool_game():
	$ToolGameSlot.set_process(false)
	$ToolGameSlot.set_visible(false)
	if $ToolGameSlot.is_connected("popup_requested", _on_popup_requested):
		$ToolGameSlot.disconnect("popup_requested", _on_popup_requested)
	
