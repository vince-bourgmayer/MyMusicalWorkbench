# -----------------------------------------------------------------------------
# input_node.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends HBoxContainer
class_name InputNode

@onready var icon = $Icon
@onready var label = $Label

const ICON_SIZE := 50

func _ready() -> void:
	set_input(2, 3, "Do action")

func set_input(x: int, y: int, text: String) -> void:
	if icon.texture is AtlasTexture:
		var tex = icon.texture.duplicate()
		tex.region.position.x = x * ICON_SIZE
		tex.region.position.y = y * ICON_SIZE
		icon.texture = tex

	label.text = text
