# -----------------------------------------------------------------------------
# hand_tools_panel.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Control

@onready var saw_icon = $ToolIconsContainer/SawIcon
@onready var plane_icon = $ToolIconsContainer/PlaneIcon
@onready var pen_icon = $ToolIconsContainer/PenIcon

var btn_group = ButtonGroup.new()
var tool_buttons : Array[BaseButton]

var active_tool_index := 0

func _ready() -> void:
	tool_buttons = [saw_icon, plane_icon, pen_icon]
	
	for icon in tool_buttons:
		icon.button_group  = btn_group
		
	Signals.switch_hand_tools.connect(select_next_tool)
	
func select_next_tool(_tool: Globals.hand_tools) -> void:
	print("Current hand tools is: ", _tool)
	active_tool_index = (active_tool_index + 1) % tool_buttons.size()
	tool_buttons[active_tool_index].set_pressed(true)
