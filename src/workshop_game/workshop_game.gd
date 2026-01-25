# -----------------------------------------------------------------------------
# WorkshopGame.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name WorkshopGame

signal popup_requested(text1: String, text2:String)
enum handTools {SAW = 3, PLANE = 4} # TODO refactor this withing an autoload, because it is same as Game.gd's popup code

@onready var player := $Player

var placementManager = PlacementManager.new()
var is_tool_to_place = true

var table_scene: PackedScene = preload("res://src/workshop_game/tools/Table.tscn")
var table_instance : Node2D
var active_tool : handTools = handTools.SAW

func _ready() -> void:
	table_instance = table_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	table_instance.visible = true
	$ToolPlaceholder.set_size(table_instance.tool_size)
	placementManager.init($Player, $ToolPlaceholder)
	add_child(placementManager)
	
	player.switch_tool.connect(_switch_tool)

func toggle_placeholder():
	if is_tool_to_place:
		$ToolPlaceholder.visible = !$ToolPlaceholder.visible

func try_to_place_tool():
	var canPlace = placementManager.checkPlace()
	if !is_tool_to_place:
		return
		
	if canPlace :
		table_instance.global_position = $ToolPlaceholder.global_position
		$Workshop/Tools.add_child(table_instance)

		is_tool_to_place = false
		toggle_placeholder()
		remove_child($ToolPlaceholder)
	else:
		print("you can't place here")

func interact_with_tool() -> void:
	popup_requested.emit("You're going to use the table as a workbench", "Press A to start", active_tool)
	
func _switch_tool() -> void:
	print("switching tool")
	if active_tool == handTools.SAW:
		active_tool = handTools.PLANE
	elif active_tool == handTools.PLANE:
		active_tool = handTools.SAW
