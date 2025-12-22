# -----------------------------------------------------------------------------
# game.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

var placementManager = PlacementManager.new()
var is_tool_to_place = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ToolPlaceholder.set_size($Table.tool_size)
	placementManager.init($Player, $ToolPlaceholder)
	add_child(placementManager)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func toggle_placeholder():
	print("button X pressed")
	if is_tool_to_place:
		$ToolPlaceholder.visible = !$ToolPlaceholder.visible
	
func try_to_place_tool():
	var canPlace = placementManager.checkPlace()
	if !is_tool_to_place:
		print("nothing to place")
		return
		
	if canPlace :
		print("you can place here")
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
