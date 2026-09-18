# -----------------------------------------------------------------------------
# carousel_item.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name CarouselItem

var _sprite : Sprite2D
var unselected_opacity := 0.5

var _previous_slot: Vector2
var _current_slot: Vector2
var _next_slot: Vector2

var _texture_path: String

func _init(path: String, previous: Vector2, current: Vector2, next: Vector2) -> void:
	_texture_path = path
	_previous_slot = previous
	_current_slot = current
	_next_slot = next
	_sprite = Sprite2D.new()
	_sprite.centered = true

func to_previous(tween: Tween):	
	_add_to_tween(tween, _previous_slot, unselected_opacity) 
	
func to_next(tween: Tween):
	_add_to_tween(tween, _next_slot, unselected_opacity) 

func to_current(tween: Tween):
	_add_to_tween(tween, _current_slot, 1.0) 

func _add_to_tween(tween: Tween, destination: Vector2, opacity: float):
	tween.parallel().tween_property(_sprite, "position", destination, 0.5)
	tween.parallel().tween_property(_sprite, "modulate:a", opacity, 0.5)

func hide(tween: Tween):
	tween.parallel().tween_property(_sprite, "modulate:a", 0.0, 0.5)

func get_visual() -> Sprite2D:
	return _sprite
	
func load_texture() -> void:
	if _sprite.texture == null:
		_sprite.texture = load(_texture_path)

func unload_texture() -> void:
	_sprite.texture = null
