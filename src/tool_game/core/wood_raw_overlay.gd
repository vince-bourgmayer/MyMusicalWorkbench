# -----------------------------------------------------------------------------
# woodboard_raw_overlay.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name WoodRawOverlay

@onready var collisionShape = $CollisionBox/CollisionShape
@onready var overlay = $Overlay

var mask : WoodLayerMask
var last_plane_pos: Vector2 = Vector2.INF

func init_mask(size: Vector2): 
	mask = WoodLayerMask.new(size)

	
func plane_at(global_pos: Vector2, strength: float) -> void:
	var local_pos = to_local(global_pos)
	
	if last_plane_pos == Vector2.INF:
		last_plane_pos = local_pos
		return
	
	_draw_line_float(last_plane_pos, local_pos, strength)
	last_plane_pos = local_pos
	mask.update_texture()
	overlay.material.set_shader_parameter(
		"thickness_mask_texture",
		mask.get_texture()
	)

func _draw_line_float(from: Vector2, to: Vector2, strength: float):
	var steps = int(from.distance_to(to)) + 1
	if steps <= 0:
		return

	for i in range(steps + 1):
		var t = float(i) / steps
		var p = from.lerp(to, t)
		var pix = mask.local_point_to_pixel_point(p)

		var mask_image = mask.get_image()
		pix.x = clamp(pix.x, 0, mask_image.get_width() - 1)
		pix.y = clamp(pix.y, 0, mask_image.get_height() - 1)
		
		_apply_rect_brush(pix, strength, 8, 1)


func _apply_rect_brush(center: Vector2i, strength: float, half_w: int, half_h: int) -> void:
	var mask_image = mask.get_image()
	var w = mask_image.get_width()
	var h = mask_image.get_height()

	for dy in range(-half_h, half_h + 1):
		for dx in range(-half_w, half_w + 1):
			var x = center.x + dx
			var y = center.y + dy
			if x < 0 or y < 0 or x >= w or y >= h:
				continue
			_apply_cut_at_pixel(Vector2i(x, y), strength)

func _apply_cut_at_pixel(pix: Vector2i, strength: float) -> void:
	var mask_image = mask.get_image()
	var old = mask_image.get_pixel(pix.x, pix.y).r  # 0..1
	var amount = strength * 0.02 # à tuner
	var newv = clamp(old - amount, 0.0, 1.0)
	mask_image.set_pixel(pix.x, pix.y, Color(newv, newv, newv))
	
func _reset_last_plane_pos():
	last_plane_pos = Vector2.INF
