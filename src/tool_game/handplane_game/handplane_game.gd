# -----------------------------------------------------------------------------
# handplane_game.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandPlaneGame

@onready var jackplane = $JackPlane
@onready var woodboard = $WoodboardToPlane

enum gameState { PLACE=0, PLANE=1, RESTART=2 }

var state : gameState
var startLine: Segment
var start_point: Vector2
var start_lerp := 0.5
var lerp_step := 0.000001

func _ready() -> void:
	startLine = get_start_line()
	start_point = startLine.start.lerp(startLine.end, start_lerp)
	set_plane_on_start_line()
	pass # Replace with function body.

func get_start_line() -> Segment:
	return woodboard.get_wood_edges()[2]
	
func set_plane_on_start_line() -> void:
	#start_lerp = 0.5
	var tw := create_tween()
	tw.tween_property(jackplane, "position", start_point, start_lerp)
	await tw.finished
	state = gameState.PLACE


#func _game_loop() -> void:
#
	#2. place the plane at the middle of this edge
		#A. get center of nose's collision box, as the reference point
		#B. Place the place with this point of the line
		#C. Let player use controls to move the plane of the edge's line.
	#3. Start planing


func _process(_delta: float) -> void:
	if state == gameState.PLACE:
		start_lerp = clamp(start_lerp+lerp_step, 0.0, 1.0)
		jackplane.position = startLine.start.lerp(startLine.end, start_lerp)
	pass

func handle_specific_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		cancel_game("Do you want to stop planing ?", "Press A to validate")
		return
		
	match state:
		gameState.PLACE:
			handle_place_plane_input(event)
		gameState.PLANE:
			handle_planing_input(event)
		_: pass
			
	#if event.is_action("ui_up") || event.is_action("ui_down") || event.is_action("ui_left") || event.is_action("ui_right"):
		#if event.is_pressed():
			#jackplane.set_rotating(true)
		#elif event.is_released():
			#jackplane.set_rotating(false)


func handle_place_plane_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start_point = jackplane.position
		state = gameState.PLANE
		jackplane.back_area_exited.connect(_on_stroke_finished)	
		return

	var strength_down = event.get_action_strength("ui_down")
	var strength_up = event.get_action_strength("ui_up")
	lerp_step =  (strength_down - strength_up) * 0.01


func handle_planing_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		if event.is_pressed():
			jackplane.push(true)
		elif event.is_released():
			jackplane.push(false)

	if event.is_action_released("trigger_left"):
		jackplane.press_front(event.get_action_strength("trigger_left"))
			
	if event.is_action("trigger_right"):
		jackplane.press_back(event.get_action_strength("trigger_right"))

func _on_stroke_finished() -> void:
	if jackplane.is_connected("back_area_exited", _on_stroke_finished):
		jackplane.disconnect("back_area_exited", _on_stroke_finished)
	#state = gameState.RESTART
	set_plane_on_start_line()
