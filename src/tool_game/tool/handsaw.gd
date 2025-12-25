# -----------------------------------------------------------------------------
# handsaw.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

@onready var visual = $visual
var visual_origin : Vector2 
var action := 0 # 0: idle, 1: push, 2: pull
var action_distance := 0 # La distance parcouru par la scie > 0 : push distance, < 0 : pull distance
const sawblade_length:= 105 # depend on the sawblade's length
const distance_per_frame := 15 # speed of the sawing movement

const cut_increment := 0.1 # step of the cut progress


func _ready() -> void:
	print("Saw is ready")
	visual_origin = visual.global_position # Store the origin position of the saw 
	#rotation = 45 # tourne la scie

# Move below code to HandsawGame later
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("push_saw"):
		action = 1
	elif event.is_action_pressed("pull_saw"):
		action = 2
	elif event.is_action_released("push_saw") || event.is_action_released("pull_saw"):
		action = 0
	pass

func make_progress():
	position.y += cut_increment

func _process(_delta: float) -> void:
	if action == 1 && action_distance < sawblade_length:
		push_saw()
		make_progress()
	elif action == 2 && action_distance > sawblade_length*-1 :
		pull_saw()
		make_progress()
		
		
func push_saw():
	action_distance += distance_per_frame
	$visual.position.y -= distance_per_frame
	
func pull_saw():
	action_distance -= distance_per_frame
	$visual.position.y += distance_per_frame
	
func plunge():
	pass
	
func raise():
	pass
