# -----------------------------------------------------------------------------
# woodboard.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

@onready var remaining_wood_border : CollisionPolygon2D = $BorderArea2D/RemainingWoodBorder
@onready var border_area2D := $BorderArea2D


var polygonSlicer : PolygonSlicer

var mask_image : Image
var mask_texture : ImageTexture

func _ready():
	polygonSlicer = PolygonSlicer.new(Vector2.ZERO)
	init_mask()
	
func init_mask(): # The mask used to hide wood wastes
	var size = $BodyBlank.texture.get_size()

	mask_image = Image.create(
		size.x,
		size.y,
		false,
		Image.FORMAT_L8
	)

	mask_image.fill(Color.WHITE)
	mask_texture = ImageTexture.create_from_image(mask_image)
	
	$BodyBlank.material.set_shader_parameter("mask_texture", mask_texture)
	
func get_remaining_wood_border() -> Array[Segment]:
	var result: Array[Segment] = []
	var points = remaining_wood_border.polygon
	for i in points.size():
		var start = points[i]
		var end = points[(i + 1) % points.size()]  # % is used to loop and then make a continuous the circuit
		result.append(Segment.new(start, end))
	return result

func add_new_cut(startPoint: Vector2, endPoint: Vector2) -> void:
	var cut_result = polygonSlicer.cut_polygon(remaining_wood_border.polygon, startPoint, endPoint)
	remaining_wood_border.polygon = cut_result[0]
	hide_cut_waste(polygon_to_pixel(remaining_wood_border.polygon))
	
func polygon_to_pixel(p_polygon: PackedVector2Array) -> PackedVector2Array:
	var pixel_polygon := PackedVector2Array()
	for p in p_polygon:
		pixel_polygon.append(local_point_to_pixel_point(p))  # Conversion ici !
	return pixel_polygon
		
		
func local_point_to_pixel_point(point: Vector2) -> Vector2i:
	var size := mask_image.get_size()
	return Vector2i(
		int(point.x + size.x * 0.5),
		int(point.y + size.y * 0.5)
	)
		
func hide_cut_waste(p_polygon: PackedVector2Array) -> void:
	mask_image.fill(Color.BLACK)
	
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	for p in p_polygon:
		min_x = min(min_x, p.x)
		min_y = min(min_y, p.y)
		max_x = max(max_x, p.x)
		max_y = max(max_y, p.y)

	min_x = int(clamp(min_x, 0, mask_image.get_width() - 1))
	min_y = int(clamp(min_y, 0, mask_image.get_height() - 1))
	max_x = int(clamp(max_x, 0, mask_image.get_width() - 1))
	max_y = int(clamp(max_y, 0, mask_image.get_height() - 1))
	
# Clamp max values to the last valid pixel index (width-1, height-1)
# because pixel coordinates start at 0.
# Then, when iterating, use range(min, max + 1) to include the max pixel,
# since the 'range' function excludes the upper bound.
	for y in range(min_y, max_y+1):
		for x in range(min_x, max_x+1):
			var point := Vector2(x, y)
			if Geometry2D.is_point_in_polygon(point, p_polygon):
				mask_image.set_pixel(x, y, Color.WHITE)

	mask_texture.update(mask_image)
