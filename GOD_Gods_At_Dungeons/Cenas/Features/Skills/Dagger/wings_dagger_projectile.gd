extends Area2D

@export var target: Node2D = null
@export var speed: int = 200
@export var Stat_damage = 0

func _physics_process(_delta) -> void:
	if target != null:
		look_at(target.global_position)
		var tween = create_tween()
		tween.tween_property(
			self,
			"global_position",
			target.global_position,
			0.4
		).set_ease(Tween.EASE_OUT)
	else:
		global_position = get_parent().global_position
		rotation = 0

func _on_vision_area_body_entered(body):
	if body is Enemy and target == null:
		target = body

func _on_Enemy_touched(body):
	if body is Enemy:
		body.stats.TakeDamage(Stat_damage)
		visible = false
		await  get_tree().create_timer(0.5).timeout
		get_tree().call_group("Dagger_wings", "reset")
		queue_free()
