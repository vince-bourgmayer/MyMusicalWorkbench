# -----------------------------------------------------------------------------
# woodboard.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

@onready var remaining_wood_border : CollisionPolygon2D = $BorderArea2D/RemainingWoodBorder
@onready var border_area2D := $BorderArea2D
const INVISIBLE_CLOAK_MATERIAL = preload("res://src/shaders/materials/invisble_cloak_material.tres")

var polygonSlicer : PolygonSlicer

func _ready():
	polygonSlicer = PolygonSlicer.new(Vector2.ZERO)
	
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
	hide_cut_waste(cut_result[1])
	
func hide_cut_waste(p_polygon: PackedVector2Array) -> void:
	var poly = Polygon2D.new()
	poly.polygon = p_polygon
	poly.material = INVISIBLE_CLOAK_MATERIAL
	$BodyBlank/InvisibleCloak.add_child(poly)
