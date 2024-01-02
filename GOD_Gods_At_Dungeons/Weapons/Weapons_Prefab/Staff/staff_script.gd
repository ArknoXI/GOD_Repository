extends Node2D

var _states_machine

@export_category("References")
@export var Fire_Projectile = preload("res://Weapons/Projectile_Prefabs/Staff/fire_projectile.tscn")
@export var blast_scene: PackedScene
@onready var TimerGhost = $GhostTimer
@onready var animation_tree = $AnimationTree
@onready var SpriteOrder: Sprite2D = $WeaponTexture
@onready var Arm_2: Sprite2D = $Arm_2
@onready var Arm_1: Sprite2D = $Arm_1
@onready var AttackTimer: Timer = $AttackTimer
@onready var marker_ = $Marker2D

@export_category("Status")
#@export var Attack_speed: float = 0
@export var is_attacking: bool = false

func _ready() -> void:
	_states_machine = animation_tree["parameters/playback"]
	position = Vector2(0, -3)

func _physics_process(_delta):
	_states_machine.travel("Idle")
	look_to()
	animate(GameManager.get_direction(), GameManager.get_mouse())
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		spawn_projectile()
		is_attacking = true
		AttackTimer.start()

func look_to() -> void:
	animation_tree["parameters/Idle/blend_position"] = GameManager.get_direction()
	
func Spawn_fade():
	var ghost = blast_scene.instantiate()
	ghost.z_index =  SpriteOrder.z_index + 1
	ghost.set_property(marker_.global_position, Vector2(0.4, 0.4))
	get_tree().current_scene.add_child(ghost)
	
func spawn_projectile():
	TimerGhost.start()
	var projectile = Fire_Projectile.instantiate()
	get_tree().root.call_deferred("add_child", projectile)
	projectile.Stat_Damage = GameManager.player.get_node("Stats").Damage
	projectile.global_position = marker_.global_position + Vector2(2, 2)
	
func animate(Attack_dir: Vector2, Direction: Vector2):
	if Attack_dir.x > 0:
		SpriteOrder.rotation = -45
		SpriteOrder.position = Vector2(6,-5)
		SpriteOrder.flip_h = false
		marker_.position = Vector2(6,-5)
		marker_.rotation = -45
	else:
		SpriteOrder.flip_h = true
		SpriteOrder.position = Vector2(6,5)
		SpriteOrder.rotation = 180
		marker_.position = Vector2(6,5)
		marker_.rotation = 180
	look_at(Direction)

func _on_attack_timer_timeout():
	is_attacking = false
	TimerGhost.stop()
	
func _on_ghost_timer_timeout():
	Spawn_fade()
