extends Node2D

var is_active = false
@export var prefab_rain: PackedScene
var enemys: Dictionary = {}

func spawn_rain_on_enemy(enemy):
	if not is_active:
		return
	var projectile = prefab_rain.instantiate()
	add_child(projectile)
	projectile.global_position = enemys[enemy].global_position

func spawn_rain_random():
	if not is_active:
		return
	var projectile = prefab_rain.instantiate()
	add_child(projectile)
	var value: int = randi_range(0, GameManager.Cells_position.size() - 1)
	projectile.global_position = GameManager.Cells_position[value]

func _on_rain_time_timeout():
	for enemy in enemys:
		spawn_rain_on_enemy(enemy)

func _on_rain_time_random_timeout():
	for i in range(3):
		await get_tree().create_timer(0.3).timeout
		spawn_rain_random()

func _on_body_entered(body):
	if body is Enemy:
		enemys[body.name] = body

func _on_body_exited(body):
	if body is Enemy:
		enemys.erase(body.name)


