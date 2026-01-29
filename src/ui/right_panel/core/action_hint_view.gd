# -----------------------------------------------------------------------------
# action_hint_view.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends HBoxContainer
class_name ActionHintView

@onready var icon = $Icon
@onready var label = $Label

const ICON_SIZE := 50

func _ready() -> void:
	set_input(2, 3, "Do action")

func set_input(x: int, y: int, text: String) -> void:
	if icon.texture is AtlasTexture:
		var texture = icon.texture.duplicate()
		texture.region.position.x = x * ICON_SIZE
		texture.region.position.y = y * ICON_SIZE
		icon.texture = texture

	label.text = text
