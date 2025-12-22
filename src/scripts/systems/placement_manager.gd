# -----------------------------------------------------------------------------
# tool_placement_manager.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

class_name PlacementManager

var placeholder: Node2D
var player: Node2D


var current_tool_scene: PackedScene

#@onready var player = get_parent().get_node("Player")

func init(playerScene: Node2D, placeHolderScene: Node2D):
	placeholder = placeHolderScene
	player = playerScene


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if placeholder.visible: # Si visible, suivre le joueur
		var offset = Vector2(0, 66)  # décalage devant le joueur
		placeholder.global_position = player.global_position + offset
		
func checkPlace() -> bool:
	return placeholder.is_position_valid

#func toggle_placeholder_visibility(visible: bool):
	#placeholder.visible = visible

#func start_placement(tool_scene: PackedScene):
	#current_tool_scene = tool_scene
	#placeholder.visible = true
	#
	#var tool = tool_scene.instantiate() as ToolBase
	#placeholder.set_size(tool.tool_size)
	#tool.queue_free()
#
#func update_placement(player_position: Vector2):
	#placeholder.follow_player(player_position)
	#var valid = placeholder.check_collision()
	#placeholder.updateColor(valid)
	#
#func confirm_placement():
	#if placeholder.is_valid_position:
		#var tool_instance = current_tool_scene.instantiate()
		#tool_instance.global_position = placeholder.global_position
		#get_tree().current_scene.add_child(tool_instance)
