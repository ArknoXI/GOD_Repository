extends Node2D

@onready var timer = $DashDuration

func Start_Dash(Duration):
	timer.wait_time = Duration
	timer.start()
	
func Is_Dashing():
	return !timer.is_stopped()
