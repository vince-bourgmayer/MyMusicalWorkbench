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

var table_scene: PackedScene = preload("res://src/workshop_game/tools/Table.tscn")
var table_instance : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	table_instance = table_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	table_instance.visible = true
	table_instance.scale = Vector2(2,2)
	$ToolPlaceholder.set_size(table_instance.tool_size)
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
		table_instance.global_position = $ToolPlaceholder.global_position
		$Workshop/Tools.add_child(table_instance)

		is_tool_to_place = false
		toggle_placeholder()
		remove_child($ToolPlaceholder)
	else:
		print("you can't place here")

func interact_with_tool():
	popup_requested.emit("You're going to use the table as a workbench", "Press A to start", 2)


func _process(delta: float) -> void:
	pass
