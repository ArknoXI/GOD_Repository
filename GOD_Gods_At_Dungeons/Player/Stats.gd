extends Node2D

@onready var Main_node = $".."
@onready var Health_bar = $"..".get_node("Health_bar")
@export_category("Stats")
@export var Health: int
@export var Damage: int
@export var attack_range: int
@export var speed: float
@export var speed_dash: float

func _ready():
	Health_bar.init_bar(Health)

func TakeDamage(damage):
	Health -= damage
	#update barra de vida
	Health_bar.update_bar(damage)
	#tomou dano
	if get_parent() is Player:
		get_tree().call_group("Camera_player", "shake", 4.0, 0.35)
	else: 	get_tree().call_group("Camera_player", "shake", 1.0, 0.25)
	HurtS()
	if Health <= 0:
		if get_parent() is Player:
			#Main_node.queue_free()
			pass
		else:
			get_parent().to_die()

func HurtS():
	var anim = $"..".get_node("AuxAnimation")
	anim.play("hit")
	if Main_node is Player:
		get_tree().call_group("Camera_player", "hit_vignette", Vector4(1.0, 0.0, 0.0 ,1.0))
		await  get_tree().create_timer(0.35).timeout
		get_tree().call_group("Camera_player", "back_color", Vector4(0.0, 0.0, 0.0, 1.0))
		if Main_node.get_node("WeaponControl").get_child(0).name == "Dagger_":
			get_tree().call_group("Dagger_stealth", "Disable_skill")
	

func _on_collision_area_area_entered(area):
	if area is Bullet:
		TakeDamage(area.Stat_Damage)
	if get_parent() is Enemy and get_parent().target == null:
		get_parent().target = GameManager.player
		get_parent().in_range = true
