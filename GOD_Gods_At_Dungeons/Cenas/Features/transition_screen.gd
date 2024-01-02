extends CanvasLayer

@onready var fill:ColorRect = $Fill
@onready var anim = $Fill/Anim

@export_range(0, 4) var type = 2
@export_range(0.0, 2.0) var duration = 1.0

var target_level: String
signal start_game

func _ready():
	fill.material.set_shader_parameter("type", type)
	anim.speed_scale = duration
	
func get_center(active):
	if not active:
		return Vector2(0.5, 0.5)
	
	var position: Vector2 = Vector2(0, 0)
	var point_x:float = (int(GameManager.player.global_position.x) * 2.08) / 1000
	var point_y:float = (int(GameManager.player.global_position.y) * 3.7) / 1000
	position.x = point_x - int(point_x)
	position.y = point_y - int(point_y)
	print(point_x, point_y)
	return position
	
func update_Type(transition_type, pos):
	fill.material.set_shader_parameter("type", transition_type)
	fill.material.set_shader_parameter("player", pos)
	
func fade_in(_scene_path: String, transition_type: int, active = false):
	update_Type(transition_type, get_center(active))
	target_level = _scene_path
	if transition_type <= 4:
		anim.play("Fade_in")
	elif transition_type == 5:
		anim.play("Fade_in_blur")
	elif  transition_type == 6:
		anim.play("Fade_out_blur")
	
func on_animation_finished(anim_name):
	if anim_name == "Fade_in":
		get_tree().change_scene_to_file(target_level)
		anim.play("Fade_out")
	elif anim_name == "Fade_in_blur":
		get_tree().change_scene_to_file(target_level)
		anim.play("Fade_out_blur")
	elif anim_name == "Fade_out" or anim_name == "Fade_out_blur":
		fill.material.set_shader_parameter("player", Vector2(0.5, 0.5))
		emit_signal("start_game")
