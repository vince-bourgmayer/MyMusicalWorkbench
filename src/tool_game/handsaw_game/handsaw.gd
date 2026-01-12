# -----------------------------------------------------------------------------
# handsaw.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

@onready var visual = $Visual
@onready var soundEffect = $SoundEffect

var push_sound = preload("res://assets/sounds/push_saw.ogg")
var pull_sound = preload("res://assets/sounds/pull_saw.ogg")

var visual_origin : Vector2 
var action := 0 # 0: idle, 1: push, 2: pull
var action_distance := 0 # La distance parcouru par la scie > 0 : push distance, < 0 : pull distance

const sawblade_length:= 100 # depend on the sawblade's length
const distance_per_frame := 15 # speed of the sawing movement

func _ready() -> void:
	print("Saw is ready")
	visual_origin = visual.global_position # Store the origin position of the saw 

func _process(_delta: float) -> void:
	if action == 1 && action_distance < sawblade_length:
		push_move()
		get_parent().make_progress()
	elif action == 2 && action_distance > sawblade_length*-1 :
		pull_move()
		get_parent().make_progress()
		
func push_move():
	action_distance += distance_per_frame
	$Visual.position.y -= distance_per_frame
	
func pull_move():
	action_distance -= distance_per_frame
	$Visual.position.y += distance_per_frame
	
func push():
	action = 1
	if soundEffect.stream != push_sound:
		soundEffect.stop()
		soundEffect.stream = push_sound
		soundEffect.play()
	
func pull():
	action = 2
	if soundEffect.stream != pull_sound:
		soundEffect.stop()
		soundEffect.stream = pull_sound
		soundEffect.play()

func idle():
	action = 0
	soundEffect.stop()
	
func prepare_for_cut(startPoint: Vector2, angle: float) -> void:
	self.global_position = startPoint
	self.rotate(angle)
	self.visible = true
