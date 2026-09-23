extends ToolGame
class_name HandsawGameV2

enum gameState { START_POINT, END_POINT, SAW_ACTION }

var _directional_input_reader = DirectionalInputReader.new()
@onready var _handsaw : Handsaw = $Handsaw
var _woodPiece: WoodPiece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_current_state = 0
	_directional_input_reader.right_stick_direction_changed.connect(_on_right_stick_direction_changed)
	_directional_input_reader.left_stick_direction_changed.connect(_on_left_stick_direction_changed)
	self.add_child(_directional_input_reader)

func _exit_tree() -> void:
	_directional_input_reader.right_stick_direction_changed.disconnect(_on_right_stick_direction_changed)
	_directional_input_reader.left_stick_direction_changed.disconnect(_on_left_stick_direction_changed)
	_directional_input_reader.queue_free()
	_handsaw.queue_free()

	
func _on_right_stick_direction_changed(direction: Vector2) -> void:
	if not _current_state == gameState.SAW_ACTION:
		return
	print("activating saw")

func _on_left_stick_direction_changed(direction: Vector2) -> void:
	match _current_state:
		gameState.START_POINT:
			print("move start point")
			pass
		gameState.END_POINT:
			print("move end point")
			pass
		_: 
			return

func _exit_state(state: int) -> void:
	match state:
		gameState.START_POINT:
			pass
		gameState.END_POINT:
			pass
		gameState.SAW_ACTION:
			pass
	
func _enter_state(new_state: int) -> void:
	match new_state:
		gameState.START_POINT:
			pass
		gameState.END_POINT:
			pass
		gameState.SAW_ACTION:
			pass
	
func _get_final_state() -> int:
	return gameState.SAW_ACTION # Overide in child.  Must return the highest game_state's value
	
func _on_game_cancelled() -> void:
	cancel_game("Do you want to stop sawing ?", "Press A to validate")
