# -----------------------------------------------------------------------------
# wood_renderer.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Sprite2D
class_name WoodRenderer

var _texture: ImageTexture

func bind(wood_piece: WoodPiece) -> void:
	#Todo find a way to provide manage texture from geometry also
	_texture = ImageTexture.create_from_image(wood_piece.get_surface_data())
	self.material.set_shader_parameter("mask_texture", _texture)
	wood_piece.surface_changed.connect(_on_surface_changed)
	wood_piece.geometry_changed.connect(_on_geometry_changed)
	
func unbind(wood_piece: WoodPiece) -> void:
	wood_piece.surface_changed.disconnect(_on_surface_changed)
	wood_piece.geometry_changed.disconnect(_on_geometry_changed)

func _on_surface_changed(surface: WoodSurface) -> void:
		_texture.update(surface.get_data().get_image())
		
func _on_geometry_changed(geometry: PackedVector2Array) -> void:
	if geometry == null or geometry.is_empty():
		return
	var texture_image = _texture.get_image()
	#TODO apply transformation
	_texture.update(texture_image)

func get_wood_size() -> Vector2:
		return texture.get_size()
