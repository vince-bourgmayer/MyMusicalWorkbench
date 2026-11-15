# -----------------------------------------------------------------------------
# wood_renderer.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Sprite2D
class_name WoodRenderer

var _surface_texture: ImageTexture
var _geometry_texture : ImageTexture
var _thickness_texture : ImageTexture
var _raw_wood_texture : ImageTexture #TMP for debug

var _geometry_painter : WoodTexturePainter

func bind(wood_piece: WoodPiece) -> void:

	_geometry_painter = WoodTexturePainter.new(wood_piece._origin_size, Image.FORMAT_L8, Color.WHITE)
	_geometry_texture = ImageTexture.create_from_image(_geometry_painter.get_image())
	_raw_wood_texture = ImageTexture.create_from_image(wood_piece.get_thickness_data())
	_thickness_texture = ImageTexture.create_from_image(wood_piece
	.get_thickness_data())
	_surface_texture = ImageTexture.create_from_image(wood_piece.get_surface_data())
	
	self.material.set_shader_parameter("surface_data", _surface_texture)
	self.material.set_shader_parameter("geometry_data", _geometry_texture)
	self.material.set_shader_parameter("thickness_data", _thickness_texture)
	self.material.set_shader_parameter("raw_wood_data", _raw_wood_texture)
	
	wood_piece.surface_changed.connect(_on_surface_changed)
	wood_piece.geometry_changed.connect(_on_geometry_changed)
	
func unbind(wood_piece: WoodPiece) -> void:
	wood_piece.surface_changed.disconnect(_on_surface_changed)
	wood_piece.geometry_changed.disconnect(_on_geometry_changed)

func _on_surface_changed(surface: WoodSurface) -> void:
		_surface_texture.update(surface.get_data().get_image())
		
func _on_geometry_changed(geometry: PackedVector2Array) -> void:
	if geometry == null or geometry.is_empty():
		return

	_geometry_painter.rasterize_shape(geometry)
	_geometry_texture.update(_geometry_painter.get_image())
	var texture_image = _geometry_texture.get_image()
	_geometry_texture.update(texture_image)

func get_wood_size() -> Vector2:
		return texture.get_size()
