# -----------------------------------------------------------------------------
# game.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

@onready var workshopGame = $WorkshopGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	workshopGame.popup_requested.connect(_on_popup_requested)
	showPopup()

func _on_popup_requested(text1:String, text2:String):
	$UI/Popup.updateText(text1, text2)
	showPopup()

func showPopup():
	$UI/Popup.show()
	$UI/Popup._popup_closed.connect(_on_popup_closed)

func _on_popup_closed():
	print("pop up is closed")
	$UI/Popup.hide()
