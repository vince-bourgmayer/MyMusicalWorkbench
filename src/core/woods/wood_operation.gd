# -----------------------------------------------------------------------------
# wood_operation.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodOperation

func apply_to_geometry(current: WoodGeometry) -> bool:
	return false  # inchangé par défaut

func apply_to_surface(current: WoodSurface) -> bool:
	return false

func apply_to_thickness(current: WoodThickness) -> bool:
	return false
