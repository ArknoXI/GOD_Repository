extends Area2D
class_name Bullet
@export_category("Stats")
@export var Stat_Damage: int
@export var Speed: float = 150.0


@export var blast_scene: PackedScene
@export var hit_effect: PackedScene = preload("res://Cenas/Particles/Explosion_particles/hit_explosion.tscn")
@export var estatico = false
@export var faded = false
@export var persistent = false
@export var hit_rgb: Color
var can_touch: bool = false
var direction:Vector2 = Vector2.ZERO

func _ready():
	if estatico:
		$effect.emitting = true
	if not estatico:
		randomize()
		direction = global_position.direction_to(get_global_mouse_position())
	
		var angle = direction.angle()
		rotation_degrees = rad_to_deg(angle)
	
func _physics_process(delta):
	if not estatico:
		translate(direction * delta * Speed)
	
func Spawn_fade():
	var blast = blast_scene.instantiate()
	get_tree().root.call_deferred("add_child", blast)
	if not faded:
		blast.emitting = true
		if not blast.get_child(0).name == "Delete_effect":
			blast.get_child(0).emitting = true
	blast.rotation = rotation
	blast.global_position = global_position
	
func spawn_hit():
	var hit = hit_effect.instantiate()
	hit.global_position = global_position
	hit.color = hit_rgb
	hit.emitting = true
	get_tree().root.call_deferred("add_child", hit)
	
func delete():
	queue_free()

func _on_duration_timeout():
	queue_free()


func _on_body_entered(body):
	if body.name == "New_tilemap" and can_touch:
		Spawn_fade()
		queue_free()


func _on_can_touch_timeout():
	can_touch = true


func _on_area_entered(_area):
	if _area.name == "Collision_area":
		if faded:
			Spawn_fade()
		spawn_hit()
		if not persistent:
			queue_free()
