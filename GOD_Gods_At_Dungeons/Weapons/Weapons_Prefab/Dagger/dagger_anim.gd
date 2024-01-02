extends Node2D

var _states_machine
@onready var animation_tree = $Tree

func _ready():
	_states_machine = animation_tree["parameters/playback"]



func _process(_delta):
	_states_machine.travel("Idle")
	look_to()

func look_to() -> void:
	animation_tree["parameters/Idle/blend_position"] = GameManager.get_direction()
