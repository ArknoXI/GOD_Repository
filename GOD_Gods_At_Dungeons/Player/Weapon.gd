extends Node2D
@onready var Weapon: Sprite2D = get_node("Sprite2D")

func animate(Attack_dir: Vector2, Dir: Vector2) -> void:
	if Attack_dir.x > 0:
		Weapon.flip_v = false
	elif Attack_dir.x < 0:
		Weapon.flip_v = true	
	
	look_at(Dir)
