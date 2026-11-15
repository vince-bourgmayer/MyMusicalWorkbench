# -----------------------------------------------------------------------------
# wood_thickness.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodThickness

var _painter : WoodTexturePainter

func _init(size: Vector2):
	_painter = WoodTexturePainter.new(size, Image.FORMAT_LA8, Color.TRANSPARENT) #transparency is temp

func get_data() -> WoodTexturePainter:
	return _painter
