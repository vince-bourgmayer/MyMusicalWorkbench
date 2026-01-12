# -----------------------------------------------------------------------------
# segment.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Object
class_name Segment


var start: Vector2
var end: Vector2

func _init(s: Vector2, e: Vector2):
	start = s
	end = e

func get_length() -> float:
	return (end-start).length()
	
func duplicate() -> Segment:
	return Segment.new(start, end)

func _print()-> void:
	print("Segment [",start,";",end,"]")
