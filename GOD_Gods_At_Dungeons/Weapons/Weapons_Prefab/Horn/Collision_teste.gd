extends Control

@export var color: Color

func _draw():
	var start = Vector2(0, 0)
	var p2 = Vector2(85, 85)
	draw_arc(start, start.distance_to(p2), 0, 360, 32, color, 1)

