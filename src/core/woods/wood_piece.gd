# -----------------------------------------------------------------------------
# wood_piece.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodPiece

signal thickness_changed(thickness)
signal geometry_changed(geometry)
signal surface_changed(surface)

var _thickness : WoodThickness
var _geometry : WoodGeometry
var _surfaceStates : WoodSurface

var _origin_size := Vector2.ZERO
var _specy:= "Ash" #TODO update later with kind of enum or something else

func _init(specy: String, size: Vector2):
	_origin_size = size
	_specy = specy
	_thickness = WoodThickness.new(_origin_size)
	_surfaceStates = WoodSurface.new(_origin_size)
	_geometry = WoodGeometry.new(_origin_size)

func apply(woodOperation: WoodOperation):
	if woodOperation.apply_to_geometry(_geometry):
		geometry_changed.emit(_geometry)

	if woodOperation.apply_to_surface(_surfaceStates):
		surface_changed.emit(_surfaceStates)

	if woodOperation.apply_to_thickness(_thickness):
		thickness_changed.emit(_thickness)

func get_surface_data() -> Image:
	return _surfaceStates.get_data().get_image()
