extends Node2D

var _states_machine

@export_category("References")
@export var Projectile = preload("res://Weapons/Projectile_Prefabs/Staff/fire_projectile.tscn")
@export var particle_scene: PackedScene
@onready var animation_tree = $AnimationTree
@onready var SpriteOrder: Sprite2D = $WeaponTexture
@onready var ArrowSprite: Sprite2D = $ArrowSprite
@onready var Arm_2: Sprite2D = $Arm_2
@onready var Arm_1: Sprite2D = $Arm_1
@onready var AttackTimer: Timer = $AttackTimer

@export_category("Status")
#@export var Attack_speed: float = 0
@export var is_attacking: bool = false

func _ready() -> void:
	_states_machine = animation_tree["parameters/playback"]
	position = Vector2(0, -1)

func _physics_process(_delta):
	_states_machine.travel("Idle")
	look_to()
	animate(GameManager.get_direction(), GameManager.get_mouse())
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		spawn_projectile()
		is_attacking = true
		ArrowSprite.visible = false
		AttackTimer.start()

func look_to() -> void:
	animation_tree["parameters/Idle/blend_position"] = GameManager.get_direction()
	
func Spawn_fade():
	var ghost = particle_scene.instantiate()
	ghost.z_index =  SpriteOrder.z_index + 1
	ghost.set_property(global_position, Vector2(0.4, 0.4))
	get_tree().current_scene.add_child(ghost)
	
func spawn_projectile():
	var projectile = Projectile.instantiate()
	get_tree().root.call_deferred("add_child", projectile)
	projectile.Stat_Damage = GameManager.player.get_node("Stats").Damage
	projectile.global_position = ArrowSprite.global_position
	
func animate(Attack_dir: Vector2, Direction: Vector2):
	if Attack_dir.x > 0:
		SpriteOrder.rotation = 45
		ArrowSprite.rotation = 45
		Arm_1.rotation = 45
		Arm_2.rotation = 45
		SpriteOrder.flip_v = false
		ArrowSprite.flip_v = false
	else:
		SpriteOrder.flip_v = true
		ArrowSprite.flip_v = true
		ArrowSprite.rotation = -44.7
		Arm_1.rotation = -44.5
		Arm_2.rotation = -44.5
		SpriteOrder.rotation = -44.7
		pass
	look_at(Direction)

func _on_attack_timer_timeout():
	is_attacking = false
	ArrowSprite.visible = true
