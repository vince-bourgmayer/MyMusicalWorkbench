# -----------------------------------------------------------------------------
# input_panel.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Control

@onready var gridContainer = $VBoxContainer/InputsContainer

var inputNodeScene = preload("res://src/ui/right_panel/core/InputNode.tscn")

func _ready() -> void:
	_load_inputs()

func _load_inputs() -> void:
	var input = inputNodeScene.instantiate()
	gridContainer.add_child(input)
	input.set_input(0, 3, "Accept")
	
	var input2 = inputNodeScene.instantiate()
	gridContainer.add_child(input2)
	input2.set_input(3, 3, "cancel")
	
	var input3 = inputNodeScene.instantiate()
	gridContainer.add_child(input3)
	input3.set_input(1, 3, "Place workbench")

	var input4 = inputNodeScene.instantiate()
	gridContainer.add_child(input4)
	input4.set_input(2, 3, "Use workbench")
	
	var inputMove = inputNodeScene.instantiate()
	gridContainer.add_child(inputMove)
	inputMove.set_input(0, 5, "Move")
	
	var inputSwitchTool = inputNodeScene.instantiate()
	gridContainer.add_child(inputSwitchTool)
	inputSwitchTool.set_input(2, 4, "Switch tool")
