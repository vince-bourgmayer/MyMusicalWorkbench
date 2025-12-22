# -----------------------------------------------------------------------------
# game.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

var placementManager = PlacementManager.new()

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
	$ToolPlaceholder.visible = !$ToolPlaceholder.visible
