# -----------------------------------------------------------------------------
# maskDrawer.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name MaskDrawer

var mask : WoodLayerMask
var _last_draw_position := Vector2.INF

func _init(size: Vector2):
	#TODO refactor, there is probably another strategy to instantiate woodLayerMask
	mask = WoodLayerMask.new(size)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func draw_at(point: Vector2, ):
	print("draw point at: ", point)
	var color := Color.DIM_GRAY
	var pix = mask.local_point_to_pixel_point(point)

	var mask_image = mask.get_image()
	pix.x = clamp(pix.x, 0, mask_image.get_width() - 1)
	pix.y = clamp(pix.y, 0, mask_image.get_height() - 1)
	
	mask_image.set_pixel(pix.x, pix.y, color)
	mask.update_texture()

func set_point_to_draw(point: Vector2):
	pass
