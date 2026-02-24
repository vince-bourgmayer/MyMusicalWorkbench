extends Node

enum game_mode {WORKSHOP = 0, HANDSAW = 1, HANDPLANE = 2, TEMPLATE = 3}
enum hand_tools {SAW = 0, PLANE = 1, PENCIL = 2}


var current_game_mode := game_mode.WORKSHOP
var current_hand_tools := hand_tools.SAW


func switch_to_game(game: game_mode) -> void:
	var previous_game = current_game_mode
	current_game_mode = game
	if previous_game != current_game_mode:
		Signals.switch_game_mode.emit(current_game_mode)
		

func switch_current_hand_tools() -> void:
	if current_hand_tools == hand_tools.SAW:
		current_hand_tools = hand_tools.PLANE
	elif current_hand_tools == hand_tools.PLANE:
		current_hand_tools = hand_tools.PENCIL
	elif current_hand_tools == hand_tools.PENCIL:
		current_hand_tools = hand_tools.SAW

	Signals.switch_hand_tools.emit(current_hand_tools)
