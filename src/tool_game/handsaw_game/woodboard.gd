extends Node2D

@onready var remaining_wood_border : CollisionPolygon2D = $BorderArea2D/RemainingWoodBorder
@onready var border_area2D := $BorderArea2D

func get_remaining_wood_border() -> Array[Segment]:
	var result: Array[Segment] = []
	var points = remaining_wood_border.polygon
	for i in points.size():
		var start = points[i]
		var end = points[(i + 1) % points.size()]  # % is used to loop and then close the circuit
		result.append(Segment.new(start, end))
	return result

func add_new_cut(startPoint: Vector2, endPoint: Vector2):
	print("existing points: ", remaining_wood_border.polygon.size())
	var alreadyAppended = false
	var newPoints = []
	# var sideToRemove = get_side_of_the_cut()
	for point in remaining_wood_border.polygon:
		var removePoint = should_remove_point(point, startPoint, endPoint)
		if !removePoint :
			newPoints.append(point)
		elif !alreadyAppended:
			alreadyAppended = true
			newPoints.append(startPoint)
			newPoints.append(endPoint)
	
	print("remaining points: ", newPoints.size())
	remaining_wood_border.polygon = newPoints
	pass
	
	
	
func should_remove_point(point: Vector2, lineStart: Vector2, lineEnd: Vector2) -> bool:
	return Geometry2D.segment_intersects_segment(lineStart, lineEnd, Vector2.ZERO, point) != null
