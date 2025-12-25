extends ToolGame
class_name HandsawGame

@onready var handsaw = $Handsaw

const cut_increment := 0.1 # step of the cut progress

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# Move below code to HandsawGame later
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("push_saw"):
		handsaw.push()
	elif event.is_action_pressed("pull_saw"):
		handsaw.pull()
	elif event.is_action_released("push_saw") || event.is_action_released("pull_saw"):
		handsaw.idle()

func make_progress():
	handsaw.position.y += cut_increment
