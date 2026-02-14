# -----------------------------------------------------------------------------
# wood_layer_mask.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodLayerMask

var mask_image: Image
var mask_texture: ImageTexture

func _init(size: Vector2) -> void:
	_init_mask(size)
	
func local_point_to_pixel_point(point: Vector2) -> Vector2i:
	var size := mask_image.get_size()
	return Vector2i(
		int(point.x + size.x * 0.5),
		int(point.y + size.y * 0.5)
	)
	
func get_texture():
	return mask_texture
	
func get_image():
	return mask_image
	
func update_texture() -> void:
	mask_texture.update(mask_image)
	
func _init_mask(size: Vector2):
	mask_image = Image.create(
		round(size.x),
		round(size.y),
		false,
		Image.FORMAT_L8
	)

	mask_image.fill(Color.WHITE)
	mask_texture = ImageTexture.create_from_image(mask_image)
