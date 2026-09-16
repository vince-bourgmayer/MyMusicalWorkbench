# -----------------------------------------------------------------------------
# wood_thickness.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodThickness

var _data : WoodImageData

func _init(size: Vector2):
	_data = WoodImageData.new(size, Image.FORMAT_L8, Color.WHITE)
