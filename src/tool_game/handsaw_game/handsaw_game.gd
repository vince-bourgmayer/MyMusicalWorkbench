extends ToolGame
class_name HandsawGame

enum gameState { SET_START, SET_ANGLE, SET_CUT }

@onready var handsaw = $Handsaw
@onready var woodboard = $Woodboard


var currentState: gameState = gameState.SET_START
var cutStartMarker: CutStartMarker

const cut_increment := 0.1 # step of the cut progress

func _ready() -> void:
	cutStartMarker = CutStartMarker.new()
	cutStartMarker.set_path(woodboard.get_remaining_wood_border())
	add_child(cutStartMarker)

func _process(_delta: float) -> void:
	pass

# Move below code to HandsawGame later
func _unhandled_input(event: InputEvent) -> void:
	if currentState == gameState.SET_START:
		handleStartInputs(event)
	elif currentState == gameState.SET_CUT:
		handleCutInputs(event)

		
func handleStartInputs(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		cutStartMarker.set_direction(+1)
	elif event.is_action_pressed("move_down"):
		cutStartMarker.set_direction(-1)
	elif event.is_action_released("move_up") || event.is_action_released("move_down"):
		cutStartMarker.set_direction(0)

func handleCutInputs(event: InputEvent) -> void:
	if event.is_action_pressed("push_saw"):
		handsaw.push()
	elif event.is_action_pressed("pull_saw"):
		handsaw.pull()
	elif event.is_action_released("push_saw") || event.is_action_released("pull_saw"):
		handsaw.idle()


func make_progress():
	handsaw.position.y += cut_increment
