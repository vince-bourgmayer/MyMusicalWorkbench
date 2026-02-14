extends Node2D
class_name WoodShape

signal shape_updated()

@onready var shape_polygon = $ShapeLayer/ShapePolygon
var polygonSlicer : PolygonSlicer
var layerMask: WoodLayerMask

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygonSlicer = PolygonSlicer.new(Vector2.ZERO)
	
func initialize(size: Vector2) -> void:
	var half_width = size.x / 2.0
	var half_height = size.y / 2.0
	
	self.position.x -= half_width
	self.position.y -= half_height

	init_shape(half_width, half_height)
	init_mask(size)
	
	
func init_shape(half_width: float, half_height: float) -> void:
	var points: Array[Vector2] = []
	
	var top_left = Vector2(half_width, half_height) * -1
	var top_right = Vector2(half_width, half_height * -1.0)
	var bottom_right = Vector2(half_width, half_height)
	var bottom_left = Vector2(half_width * -1.0, half_height)
	points.append_array([top_left, top_right, bottom_right, bottom_left])
	
	shape_polygon.polygon = points
	
func init_mask(size: Vector2) -> void:
	layerMask = WoodLayerMask.new(size)
	shape_updated.emit()

func get_edges_as_segment()-> Array[Segment]:
	var result: Array[Segment] = []
	var points = shape_polygon.polygon
	for i in points.size():
		var start = points[i]
		var end = points[(i + 1) % points.size()]  # % is used to loop and then make a continuous the circuit

		result.append(Segment.new(start, end))
	return result

func add_new_cut(startPoint: Vector2, endPoint: Vector2) -> void:
	var cut_result = polygonSlicer.cut_polygon(shape_polygon.polygon, startPoint, endPoint)
	shape_polygon.polygon = cut_result
	hide_cut_waste(polygon_to_pixel(shape_polygon.polygon))
	#shape_updated.emit()

func polygon_to_pixel(p_polygon: PackedVector2Array) -> PackedVector2Array:
	var pixel_polygon := PackedVector2Array()
	for p in p_polygon:
		pixel_polygon.append(layerMask.local_point_to_pixel_point(p))  # Conversion ici !
	return pixel_polygon
		
func hide_cut_waste(p_polygon: PackedVector2Array) -> void:
	var mask_image = layerMask.get_image()
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

	layerMask.update_texture()

func get_mask_texture() -> ImageTexture:
	return layerMask.get_texture()
