# -----------------------------------------------------------------------------
# wood_image_data.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodImageData

var _image: Image
var _origin_size: Vector2

func _init(size: Vector2, format: Image.Format, fill_color: Color = Color.BLACK):
	_image = Image.create_empty(int(size.x), int(size.y), false, format)
	_image.fill(fill_color)
	_origin_size = size

func _local_point_to_pixel_point(point: Vector2) -> Vector2i:
	return Vector2i(
		int(point.x + _origin_size.x * 0.5),
		int(point.y + _origin_size.y * 0.5)
	)

func draw_line(from: Vector2, to: Vector2, diameter: int, toolEffect: Callable) -> bool:
	var steps = int(from.distance_to(to)) + 1
	if steps <= 0:
		return false

	for i in range(steps + 1):
		var progress_ratio = float(i) / steps
		var pix_pos = from.lerp(to, progress_ratio)
		var pix = _local_point_to_pixel_point(pix_pos)

		pix.x = clamp(pix.x, 0, _origin_size.x - 1)
		pix.y = clamp(pix.y, 0, _origin_size.y - 1)
		
		@warning_ignore("integer_division")
		_apply_rect_brush(pix, diameter/2, diameter/2, toolEffect)
	return true

func _apply_rect_brush(center: Vector2i, half_w: int, half_h: int, toolEffect: Callable) -> void:
	var w = _origin_size.x
	var h = _origin_size.y

	for dy in range(-half_h, half_h + 1):
		for dx in range(-half_w, half_w + 1):
			var x = center.x + dx
			var y = center.y + dy
			if x < 0 or y < 0 or x >= w or y >= h:
				continue
			var current_pixel = _image.get_pixel(x, y)
			_image.set_pixel(x, y, toolEffect.call(current_pixel))

func get_image(): # TEMP
	return _image
