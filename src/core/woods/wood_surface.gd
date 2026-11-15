# -----------------------------------------------------------------------------
# wood_surface.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodSurface

var _painter : WoodTexturePainter

func _init(size: Vector2):
	_painter = WoodTexturePainter.new(size, Image.FORMAT_L8)

func get_data() -> WoodTexturePainter:
	return _painter
