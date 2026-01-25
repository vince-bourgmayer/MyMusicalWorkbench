# -----------------------------------------------------------------------------
# woodboard_to_plane.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name WoodBoardToPlane

@onready var visual = $Visual
@onready var collisionShape = $CollisionBox/CollisionShape
@onready var overlay = $Overlay

var mask_thickess_image : Image
var mask_thickness_texture : ImageTexture

var last_plane_pos: Vector2 = Vector2.INF

func _ready() -> void:
	init_thickness_mask()
	
	overlay.material.set_shader_parameter(
		"thickness_mask_texture",
		mask_thickness_texture
	)
	#visual.texture = mask_thickness_texture
	
# mask that represent wood's thickness. White => highest depth, black: a hole
func init_thickness_mask(): 
	var size = visual.texture.get_size()

	mask_thickess_image = Image.create(
		size.x,
		size.y,
		false,
		Image.FORMAT_L8
	)

	mask_thickess_image.fill(Color.WHITE)
	mask_thickness_texture = ImageTexture.create_from_image(mask_thickess_image)
	
	
func get_wood_edges() -> Array[Segment]:
	var result: Array[Segment] = []
	var points = collisionShape.polygon
	for i in points.size():
		var start = points[i]
		var end = points[(i + 1) % points.size()]  # % is used to loop and then make a continuous the circuit
		
		var start_global = collisionShape.to_global(start)
		var end_global = collisionShape.to_global(end)
		
		result.append(Segment.new(start_global, end_global))
	return result

func local_point_to_pixel_point(point: Vector2) -> Vector2i:
	var size := mask_thickess_image.get_size()
	return Vector2i(
		int(point.x + size.x * 0.5),
		int(point.y + size.y * 0.5)
	)
	
func plane_at(global_pos: Vector2, strength: float) -> void:
	var local_pos = to_local(global_pos)
	
	if last_plane_pos == Vector2.INF:
		last_plane_pos = local_pos
		return
	
	_draw_line_float(last_plane_pos, local_pos, strength)
	last_plane_pos = local_pos
	mask_thickness_texture.update(mask_thickess_image)

func _draw_line_float(from: Vector2, to: Vector2, strength: float):
	var steps = int(from.distance_to(to)) + 1
	if steps <= 0:
		return

	for i in range(steps + 1):
		var t = float(i) / steps
		var p = from.lerp(to, t)
		var pix = local_point_to_pixel_point(p)

		pix.x = clamp(pix.x, 0, mask_thickess_image.get_width() - 1)
		pix.y = clamp(pix.y, 0, mask_thickess_image.get_height() - 1)
		
		_apply_rect_brush(pix, strength, 8, 1)


func _apply_rect_brush(center: Vector2i, strength: float, half_w: int, half_h: int) -> void:
	var w = mask_thickess_image.get_width()
	var h = mask_thickess_image.get_height()

	for dy in range(-half_h, half_h + 1):
		for dx in range(-half_w, half_w + 1):
			var x = center.x + dx
			var y = center.y + dy
			if x < 0 or y < 0 or x >= w or y >= h:
				continue
			_apply_cut_at_pixel(Vector2i(x, y), strength)

func _apply_cut_at_pixel(pix: Vector2i, strength: float) -> void:
	var old = mask_thickess_image.get_pixel(pix.x, pix.y).r  # 0..1
	var amount = strength * 0.02 # à tuner
	var newv = clamp(old - amount, 0.0, 1.0)
	mask_thickess_image.set_pixel(pix.x, pix.y, Color(newv, newv, newv))
	
func _reset_last_plane_pos():
	last_plane_pos = Vector2.INF
