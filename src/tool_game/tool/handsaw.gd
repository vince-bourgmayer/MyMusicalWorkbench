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



func _ready() -> void:
	print("Saw is ready")
	visual_origin = visual.global_position # Store the origin position of the saw 
	#rotation = 45 # tourne la scie

func _process(_delta: float) -> void:
	if action == 1 && action_distance < sawblade_length:
		push_move()
		get_parent().make_progress()
	elif action == 2 && action_distance > sawblade_length*-1 :
		pull_move()
		get_parent().make_progress()
		
func push_move():
	action_distance += distance_per_frame
	$visual.position.y -= distance_per_frame
	
func pull_move():
	action_distance -= distance_per_frame
	$visual.position.y += distance_per_frame
	
func push():
	action = 1
	
func pull():
	action = 2

func idle():
	action = 0
