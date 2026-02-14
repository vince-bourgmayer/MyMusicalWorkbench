# -----------------------------------------------------------------------------
# woodpiece.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name WoodPiece

@onready var shape = $Shape
@onready var visual = $Visual
@onready var raw_overlay = $FeaturesLayer/WoodRawOverlay

func _ready() -> void:
	var visual_size = visual.texture.get_size()
	shape.shape_updated.connect(_on_shape_update)
	shape.initialize(visual_size)
	raw_overlay.init_mask(visual_size)

func _on_shape_update() -> void:
	var mask_texture = shape.get_mask_texture()
	self.material.set_shader_parameter("mask_texture", mask_texture)
	
func get_shape() -> WoodShape:
	return shape

func get_raw_overlay() -> WoodRawOverlay:
	return raw_overlay
