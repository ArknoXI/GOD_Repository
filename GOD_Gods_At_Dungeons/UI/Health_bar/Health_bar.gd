extends Control

@export var bar : ProgressBar
@export var ener_bar: ProgressBar

func _ready():
	if get_parent() is Player:
		ener_bar.visible = true

var currentvalue:int

func init_bar(bar_value):
	bar.max_value = bar_value
	bar.value = bar_value
	currentvalue = bar_value
	
func update_bar(value: int):
	start_tween(currentvalue, value)
	currentvalue -= value

func start_tween(old_value, new_value):
	var tween = create_tween()
	tween.tween_property(
		bar,
		"value",
		old_value - new_value,
		0.4
	)

func fill_energyBar():
	var tween = create_tween()
	tween.tween_property(
		ener_bar,
		"value",
		1,
		1
	)
