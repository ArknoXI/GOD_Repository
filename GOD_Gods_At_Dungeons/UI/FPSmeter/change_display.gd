extends CanvasLayer

@export var active: bool = false

func change():
	if active:
		#Enable
		$Control/Smooth.text = "Disable Smooth"
		get_tree().call_group("Camera_player", "smooth_disable")
	else: 
		#Disable
		$Control/Smooth.text = "Enable Smooth"
		print("Diminuiu a tela")
		get_tree().call_group("Camera_player", "smooth_disable")


func _on_button_pressed():
	active = not active
	change()


func _on_select_pressed():
	TransitionScreen.fade_in("res://Locals/class_select.tscn", 1, true)
