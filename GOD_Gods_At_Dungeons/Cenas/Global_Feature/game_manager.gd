extends Node2D
class_name Manager

var player: Player = null
var player_head: Sprite2D = null
var player_body: Sprite2D = null
var dust: CPUParticles2D = null

var Cells_position: Array = []

var texture_path_Head = ""
var texture_path_Body = ""
var weapon_type = ""


var mouse: Vector2
var mouse_dir: Vector2

func get_direction() -> Vector2:
	return mouse_dir

func get_mouse() -> Vector2:
	return mouse
