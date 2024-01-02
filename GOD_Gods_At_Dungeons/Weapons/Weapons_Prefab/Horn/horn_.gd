extends Node2D

var _states_machine

@export_category("References")
@export var Projectile :PackedScene = preload("res://Weapons/Projectile_Prefabs/Bard/bard_projectile.tscn")
@onready var animation_tree = $AnimationTree
@onready var AttackTimer: Timer = $AttackTimer

@export_category("Status")
#@export var Attack_speed: float = 0
@export var is_attacking: bool = false
@export var attack_range: float
var mouse_in_range: float

func _ready() -> void:
	_states_machine = animation_tree["parameters/playback"]
	$Area2D/CollisionShape2D.shape.radius = attack_range

func _physics_process(_delta):
	_states_machine.travel("Idle")
	look_to()
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		get_range()
		
func get_range():
	mouse_in_range = GameManager.player.global_position.distance_to(GameManager.get_mouse())
	if mouse_in_range < attack_range	:
		#spawn effects
		#spawn projetil
		$Pos/atck_effect.emitting = true
		spawn_projectile(GameManager.get_mouse())
		is_attacking = true
		AttackTimer.start()
	else:
		$Pos/atck_effect.emitting = true
		spawn_projectile(GameManager.player.global_position + Vector2(GameManager.get_direction().x * 120, GameManager.get_direction().y * 120))
		is_attacking = true
		AttackTimer.start()
	
func look_to() -> void:
	animation_tree["parameters/Idle/blend_position"] = GameManager.get_direction()

func spawn_projectile(mouse_pos):
	var projectile = Projectile.instantiate()
	get_tree().root.call_deferred("add_child", projectile)
	projectile.Stat_Damage = GameManager.player.get_node("Stats").Damage
	projectile.global_position = mouse_pos


func _on_attack_timer_timeout():
	is_attacking = false
