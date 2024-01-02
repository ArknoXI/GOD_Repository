extends Node2D

@export_category("References")
@export var Projectile = preload("res://Weapons/Projectile_Prefabs/Dagger/dagger_projectile.tscn")
@onready var SpriteOrder: Sprite2D = $WeaponTexture
@onready var Arm_1: Sprite2D = $Arm_1
@onready var AttackTimer: Timer = $Attack_Timer

@export_category("Status")
#@export var Attack_speed: float = 0
@export var is_attacking: bool = false

func _physics_process(_delta):
	animate(GameManager.get_mouse())
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		#spawn Projetil
		get_tree().call_group("Dagger_stealth", "Disable_skill")
		Spawn_Projectile()
		SpriteOrder.visible = false
		is_attacking = true
		AttackTimer.start()
	
func animate(Direction: Vector2):
	look_at(Direction)

func Spawn_Projectile():
	var projectile = Projectile.instantiate()
	get_tree().root.call_deferred("add_child", projectile)
	projectile.Stat_Damage = GameManager.player.get_node("Stats").Damage
	projectile.global_position = global_position

func _on_attack_timer_timeout():
	SpriteOrder.visible = true
	is_attacking = false
