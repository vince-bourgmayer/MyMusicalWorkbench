# -----------------------------------------------------------------------------
# tool_placeholder.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

const color_invalid := Color(Color.RED, 0.5)
const color_valid := Color(Color.GREEN, 0.5)
var texture = create_placeholder_texture()

@onready var visual = $Visual

func _ready() -> void:
	$Visual.texture = texture
	updateColor(true)
	set_size(Vector2(128, 64))

	
func create_placeholder_texture() -> ImageTexture:
	var img = Image.create_empty(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color(1,1,1, 0.5))
	return ImageTexture.create_from_image(img)

func set_size(size: Vector2):
	print("set size: ", size)
	$Visual.scale = size  / texture.get_size()  #=> for when texture is not 1x1
	var shape = $BaseArea/BaseCollision.shape as RectangleShape2D
	shape.size = size

func updateColor(isValid: bool):
	print("updatecolor: ", isValid)
	if isValid:
		$Visual.modulate = color_valid
	else:
		$Visual.modulate = color_invalid
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
