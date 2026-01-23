# -----------------------------------------------------------------------------
# woodboard_to_plane.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name WoodBoardToPlane

@onready var visual = $Visual
var mask_thickess_image : Image
var mask_thickness_texture : ImageTexture

func _ready() -> void:
	init_thickness_mask()
	
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
	

func _process(_delta: float) -> void:
	pass
