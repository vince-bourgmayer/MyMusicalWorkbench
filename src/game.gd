# -----------------------------------------------------------------------------
# game.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

const startMessage_popup = 0
const openWorkshopGame_popup = 1
const openToolGame_popup = 2

@onready var workshopGame = $WorkshopGame

func _ready() -> void:
	pause_tool_game()
	workshopGame.popup_requested.connect(_on_popup_requested)
	showPopup()

func _on_popup_requested(text1:String, text2:String, code: int):
	$UI/Popup.setCode(code)
	$UI/Popup.updateText(text1, text2)
	showPopup()

func showPopup():
	$UI/Popup.show()
	$UI/Popup._popup_closed.connect(_on_popup_closed)

func _on_popup_closed(code: int):
	print("pop up is closed")
	$UI/Popup.hide()
	if code == openToolGame_popup:
		pause_workshop_game()
		start_tool_game()
	elif code == openWorkshopGame_popup:
		pause_tool_game()
		start_workshop_game()

func start_workshop_game():
	print("Open Workshop game scene")
	$WorkshopGame.set_process(true)
	$WorkshopGame.set_visible(true)

func pause_workshop_game():
	print("pause workshop game scene")
	$WorkshopGame.set_process(false)
	$WorkshopGame.set_visible(false)

func start_tool_game():
	print("Open Tool game scene")
	$ToolGame.set_process(true)
	$ToolGame.set_visible(true)

func pause_tool_game():
	print("pause Tool game scene")
	$ToolGame.set_process(false)
	$ToolGame.set_visible(false)
