extends CharacterBody2D
class_name Enemy


@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var auxanimation: AnimationPlayer = $AuxAnimation
@onready var stats = get_node("Stats")
@onready var Particle:PackedScene = preload("res://Cenas/Particles/Explosion_particles/explosion_particles.tscn")
@onready var hit_particles: PackedScene = preload("res://Cenas/Particles/Explosion_particles/robot_hit.tscn")
@export_category("Variables")
@export var _enemy_type:String = "chase" #Persegue, corre
@export var is_alive = true
@export var in_range: bool = false
@export var is_attacking: bool = false
@onready var vision_range = $Vision_area/CollisionShape2D
@onready var range_attack: int = stats.attack_range
@onready var move_speed: float = stats.speed

func _ready():
	$Attack_area/CollisionShape2D.shape.radius = range_attack

func _physics_process(_delta):
	if GameManager.player == null:
		return
	if not is_alive:
		return
	if not in_range and not is_attacking:
		animation.play("idle")
		vision_range.shape.radius = 110
		return
		
	vision_range.shape.radius = 190
	
	var _direction: Vector2 = global_position.direction_to(GameManager.player.global_position)
	var _distance: float = global_position.distance_to(GameManager.player.global_position)
	
	if _direction.y > 0:
		$Texture.z_index = 2
	else:
		$Texture.z_index = 7
	
	if _direction.x > 0:
		$Texture.flip_h = false
	elif _direction.x < 0:
		$Texture.flip_h = true
	
	if _distance < range_attack:
		#ataque
		is_attacking = true
		animation.play("attack")
		
	match _enemy_type:
		"chase":
			#persegue
			_chase(_direction)
				
		"chase_and_dash":
			#persegue e dash
			_chase_and_dash()
		"shooter":
			#atira de longe
			_shooter()
	if not is_attacking:
		move_and_slide()
		
func _chase(_direction: Vector2):
	velocity = _direction * move_speed
	if not is_attacking:
		animation.play("run")
	#print("Seguindo...")
	
func _chase_and_dash(_direction: Vector2 = Vector2(0,0)):
	pass
	
func _shooter():
	pass

func die():
	queue_free()

func to_die():
	is_alive = false
	animation.play("hurt")
	
func Spawn_particle():
	var _particle: CPUParticles2D = Particle.instantiate()
	_particle.global_position = global_position + Vector2(0, -20)
	_particle.emitting = true
	get_tree().root.call_deferred("add_child", _particle)
	
func Hit_spawn():
	var _particles: CPUParticles2D = hit_particles.instantiate()
	get_tree().root.call_deferred("add_child", _particles)
	_particles.global_position = global_position #+ Vector2(0, -20)
	_particles.emission_sphere_radius = range_attack
	_particles.emitting = true
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
		

func _on_attack_area_body_entered(body):
	if body is Player and is_attacking:
		body.stats.TakeDamage(stats.Damage)


func _on_vision_area_body_entered(body):
	if body is Player:
		in_range = true

func _on_vision_area_body_exited(body):
	if body is Player:
		in_range = false
