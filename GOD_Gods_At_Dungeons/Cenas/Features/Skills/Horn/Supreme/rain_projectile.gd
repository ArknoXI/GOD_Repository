extends Node2D

@export var Stat_damage: float = 5
@export var effect_prefab: PackedScene

func _ready():
	do_tween()
	
func do_tween():
	var tween = create_tween()
	tween.parallel().tween_property(
		$Texture,
		"position",
		$Texture_shadow.position,
		1
	)
	tween.parallel().tween_property(
		$Texture_shadow,
		"scale",
		Vector2(1,1),
		1
	)
	await tween.finished
	$Collision_area/CollisionShape2D.disabled = false
	$Texture_shadow.queue_free()
	$Texture.queue_free()
	Insta()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func Insta():
	var projectile = effect_prefab.instantiate()
	get_parent().add_child(projectile)
	projectile.Stat_Damage = Stat_damage
	projectile.global_position = global_position

func _on_collision_area_area_entered(area):
	if area.get_parent() is Enemy:
		area.get_parent().stats.TakeDamage(Stat_damage)
