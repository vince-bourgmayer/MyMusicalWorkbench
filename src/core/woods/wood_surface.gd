# -----------------------------------------------------------------------------
# wood_surface.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodSurface

var _data : WoodImageData

func _init(size: Vector2):
	_data = WoodImageData.new(size, Image.FORMAT_L8)

func get_data():
	return _data
