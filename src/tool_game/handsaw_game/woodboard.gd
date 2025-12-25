extends Node2D

@onready var remaining_wood_border := $RemainingWoodBorder


func get_remaining_wood_border() -> Array[Segment]:
	var result: Array[Segment] = []
	var points = remaining_wood_border.polygon
	for i in points.size():
		var start = points[i]
		var end = points[(i + 1) % points.size()]  # % is used to loop and then close the circuit
		result.append(Segment.new(start, end))
	return result
