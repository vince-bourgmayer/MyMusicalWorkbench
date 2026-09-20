extends Sprite2D
class_name WoodRenderer

var _texture: ImageTexture

func bind(wood_piece: WoodPiece) -> void:
	_texture = ImageTexture.create_from_image(wood_piece.get_surface_data())
	self.material.set_shader_parameter("mask_texture", _texture)
	wood_piece.surface_changed.connect(_on_surface_changed)

func _on_surface_changed(surface: WoodSurface) -> void:
		_texture.update(surface.get_data().get_image())
