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

@export var _size: Vector2

func _ready() -> void:
	_size = visual.texture.get_size()
	shape.shape_updated.connect(_on_shape_update)
	shape.initialize(_size)
	raw_overlay.init_mask(_size)

func _on_shape_update() -> void:
	var mask_texture = shape.get_mask_texture()
	self.material.set_shader_parameter("mask_texture", mask_texture)
	
func get_shape() -> WoodShape:
	return shape

func get_raw_overlay() -> WoodRawOverlay:
	return raw_overlay

func get_size():
	return _size # #TODO size will be null if method called before _read
