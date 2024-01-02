extends Control

func _ready():
	TransitionScreen.anim.play("Fade_out_blur")

func on_timer_timeout():
	TransitionScreen.fade_in("res://Locals/Menu_Screen.tscn", 5)
