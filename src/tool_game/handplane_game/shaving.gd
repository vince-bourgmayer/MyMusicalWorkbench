extends Node2D
class_name Shaving

@onready var frontstrip = $FrontStrip
@onready var backstrip = $BackStrip

var back_len := 0.0
var front_len := 0.0

var back_len_max := 40
var front_len_max := 20.0

var back_speed := 150.0
var front_speed := 75.0

var step := 8.0

var phase := 0 # 0 = back grows, 1 = front grows


func start():
	reset()
	backstrip.visible = true
	frontstrip.visible = true
	backstrip.add_point(Vector2.ZERO)
	frontstrip.add_point(Vector2.ZERO)

func update(delta: float, _pressure: float):
	var back_rate := back_speed 
	var front_rate := front_speed 
	if phase == 0:
		# sort vers l’arrière : +X
		back_len = min(back_len + back_rate * delta, back_len_max)
		_update_line(backstrip, back_len, +1)
		if back_len >= back_len_max:
			phase = 1
	elif phase == 1:
		frontstrip.position = Vector2(back_len, 0)
		# face qui “revient” vers le nez : -X
		front_len = min(front_len + front_rate * delta, front_len_max)
		_update_line(frontstrip, front_len, -1)

func end():
	reset()


func reset():
	backstrip.clear_points()
	frontstrip.clear_points()
	backstrip.visible = false
	frontstrip.visible = false
	back_len = 0.0
	front_len = 0.0
	phase = 0

func _update_line(line: Line2D, length: float, dir: int) -> void:
	var wanted_points := int(floor(length / step)) + 1
	while line.get_point_count() < wanted_points:
		var i := line.get_point_count()
		var x := float(i) * step * float(dir)

		# Micro irrégularité très faible (évite l’aspect trop "règle")
		var y := sin(float(i) * 0.6) * 1.0

		line.add_point(Vector2(x, y))


func _curve_point(x: float) -> Vector2:
	# x en pixels le long du copeau
	# amplitude forte au début, puis décroît
	var amp0 := 10.0
	var amp := amp0 * exp(-x * 0.02)  # amortissement rapide

	# une seule ondulation douce, pas un serpent
	var wave := sin(x * 0.18) * amp

	# "curl" doux qui se stabilise (pas linéaire)
	var curl := -20.0 * (1.0 - exp(-x * 0.03))

	return Vector2(x, wave + curl)
