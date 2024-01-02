extends Control

func _ready():
	for button in get_tree().get_nodes_in_group("Button"):
		button.pressed.connect(main_buttons.bind(button.name))
		
func main_buttons(button_name):
	if button_name == "Resume_Button":
		return
	if button_name == "NewGame_Button":
		TransitionScreen.fade_in("res://Locals/class_select.tscn", 3)
		return
	if button_name == "Options_Button":
		return
	if button_name == "Quit_Button":
		get_tree().quit()
