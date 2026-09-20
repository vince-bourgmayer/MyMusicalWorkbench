# -----------------------------------------------------------------------------
# carousel.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name Carousel

signal selection_changed()

@export var previousSlot: Vector2 = Vector2(0,360)
@export var currentSlot: Vector2 = Vector2(480,360)
@export var nextSlot: Vector2 = Vector2(960,360)

var _item_paths: Array[String] = []
var _items: Array[CarouselItem] = []
var _current_selection := 0

func setup(paths: Array[String]) -> void:
	_item_paths = paths
	for item in _items:
		item.queue_free()
	_items.clear()

	for i in _item_paths.size():
		var item: CarouselItem = CarouselItem.new(_item_paths[i], previousSlot, currentSlot, nextSlot)
		add_child(item.get_visual())
		_items.append(item)

	_current_selection = 0
	_update_carousel(false)

func select_previous():
	if _items.is_empty():
		return
	_current_selection = (_current_selection - 1 + _items.size()) % _items.size()
	_update_carousel(true)
	selection_changed.emit()
	
func select_next():
	if _items.is_empty():
		return
	_current_selection = (_current_selection + 1) % _items.size()
	_update_carousel(true)
	selection_changed.emit()
	
func get_selected_path() -> String:
	return _item_paths[_current_selection]

func _update_carousel(animated: bool) -> void:
	var tween := create_tween()
	for i in _items.size():
		var item := _items[i]
		var distance := _get_circular_distance(i)

		if absi(distance) <= 1:
			item.load_texture()
		else:
			item.unload_texture()

		match distance:
			-1: item.to_previous(tween)
			0: item.to_current(tween)
			1: item.to_next(tween)
			_: item.hide(tween)
			
	if not animated:
		tween.custom_step(999.0)  # applique instantanément, sans animer, au setup initial

func _get_circular_distance(index: int) -> int:
	var size := _items.size()
	var distance := index - _current_selection
	if distance > size / 2.0:
		distance -= size
	elif distance < -size / 2.0:
		distance += size
	return distance

func on_input_received(direction: Vector2):
	if direction.x < 0.0:
		select_previous()
	elif direction.x > 0.0:
		select_next()
	
