# -----------------------------------------------------------------------------
# WorkshopGame.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name WorkshopGame

signal popup_requested(text1: String, text2:String)

var placementManager = PlacementManager.new()
var is_tool_to_place = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ToolPlaceholder.set_size($Table.tool_size)
	placementManager.init($Player, $ToolPlaceholder)
	add_child(placementManager)

func toggle_placeholder():
	if is_tool_to_place:
		$ToolPlaceholder.visible = !$ToolPlaceholder.visible

func try_to_place_tool():
	var canPlace = placementManager.checkPlace()
	if !is_tool_to_place:
		return
		
	if canPlace :
		var table = $Table
		remove_child($Table)
		$World/Tools.add_child(table)
		table.visible = true
		is_tool_to_place = false
		table.global_position = $ToolPlaceholder.global_position
		table.scale = Vector2(2,2)
		toggle_placeholder()
		remove_child($ToolPlaceholder)
	else:
		print("you can't place here")

func interact_with_tool():
	popup_requested.emit("You're going to use the table as a workbench", "Press A to start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
