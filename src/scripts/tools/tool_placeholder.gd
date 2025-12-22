# -----------------------------------------------------------------------------
# tool_placeholder.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

const color_invalid := Color(Color.RED, 0.5)
const color_valid := Color(Color.GREEN, 0.5)
var texture = create_placeholder_texture()

var is_position_valid: bool = false

@onready var visual = $Visual

func _ready() -> void:
	$Visual.texture = texture
	
func create_placeholder_texture() -> ImageTexture:
	var img = Image.create_empty(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color(1,1,1, 0.5))
	return ImageTexture.create_from_image(img)

func set_size(size: Vector2):
	$Visual.scale = size  / texture.get_size()  #=> for when texture is not 1x1
	var shape = $BaseArea/BaseCollision.shape as RectangleShape2D
	shape.size = size

func update_color(isValid: bool):
	if isValid:
		$Visual.modulate = color_valid
	else:
		$Visual.modulate = color_invalid
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_base_area_body_entered(_body: Node2D) -> void:
	is_position_valid = false
	update_color(is_position_valid)


func _on_base_area_body_exited(_body: Node2D) -> void:
	is_position_valid = true
	update_color(is_position_valid)
