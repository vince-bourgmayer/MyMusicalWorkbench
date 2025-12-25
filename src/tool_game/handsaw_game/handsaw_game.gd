extends ToolGame
class_name HandsawGame

enum gameState { SET_START, SET_ANGLE, SET_CUT }

@onready var handsaw = $Handsaw
@onready var woodboard = $Woodboard


var currentState: gameState = gameState.SET_START
var cutStartMarker: CutStartMarker
var cutEndMarker: CutStartMarker
var cutline : Line2D = Line2D.new()

var cut_increment := 0.0 # step of the cut progress

func _ready() -> void:
	cutStartMarker = CutStartMarker.new()
	cutStartMarker.set_path(woodboard.get_remaining_wood_border())
	add_child(cutStartMarker)
	
	cutEndMarker = CutStartMarker.new(Color.BLUE)
	cutEndMarker.set_path(woodboard.get_remaining_wood_border())
	cutEndMarker.visible = false
	add_child(cutEndMarker)
	cutline.default_color = Color.BLUE
	cutline.width = 4
	cutline.visible = false

	cutline.add_point(cutStartMarker.position)
	cutline.add_point(cutEndMarker.position)
	add_child(cutline)
	
	handsaw.top_level = true

func _process(_delta: float) -> void:
	if currentState == gameState.SET_ANGLE:
		cutline.set_point_position(0, cutStartMarker.position)
		cutline.set_point_position(1, cutEndMarker.position)

func _unhandled_input(event: InputEvent) -> void:
	if currentState == gameState.SET_START:
		handleStartInputs(event, cutStartMarker)
	elif currentState == gameState.SET_ANGLE:
		handleStartInputs(event, cutEndMarker)
	elif currentState == gameState.SET_CUT:
		handleCutInputs(event)

func handleStartInputs(event: InputEvent, marker: CutStartMarker) -> void:
	if event.is_action_pressed("move_up"):
		marker.set_direction(+1)
	elif event.is_action_pressed("move_down"):
		marker.set_direction(-1)
	elif event.is_action_released("move_up") || event.is_action_released("move_down"):
		marker.set_direction(0)
	if event.is_action_released("place_tool"):
		if currentState == gameState.SET_START:
			currentState = gameState.SET_ANGLE
			cutEndMarker.visible = true
			cutline.visible = true
		elif currentState == gameState.SET_ANGLE:
			cutStartMarker.visible = false
			cutEndMarker.visible = false
			currentState = gameState.SET_CUT
			var cut_angle = get_cutline_angle()
			handsaw.position = cutStartMarker.position
			handsaw.rotate(cut_angle)


func handleCutInputs(event: InputEvent) -> void:
	if event.is_action_pressed("push_saw"):
		handsaw.push()
	elif event.is_action_pressed("pull_saw"):
		handsaw.pull()
	elif event.is_action_released("push_saw") || event.is_action_released("pull_saw"):
		handsaw.idle()

func make_progress():
	if cut_increment < 1.0:
		cut_increment+= 0.001
		print(cut_increment)
		handsaw.position = cutStartMarker.position.lerp(cutEndMarker.position, cut_increment)

func get_cutline_angle() -> float:
	return ((cutStartMarker.position - cutEndMarker.position).angle_to(Vector2(0,1)) +3.141593 )* -1
