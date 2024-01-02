extends Node2D

@onready var Icon = $Skill_Icon/HBoxContainer/Skill/TextureProgressBar
@export var Duration = 5
@export var cooldown_time = 9.0
@export var cooldown: Timer

func _ready():
	cooldown.wait_time = cooldown_time
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("Skill_1") and cooldown.is_stopped():
		print("Oi")
		Active_skill()
		await  get_tree().create_timer(Duration).timeout
		Disable_skill()

func Active_skill():
	cooldown.start()
	Do_tween()
	GameManager.player.trail.modulate.a = 0.0
	GameManager.player.set_collision_layer(4)
	get_tree().call_group("Camera_player", "hit_tween", Vector4(0.0, 0.0, 1.0, 1.0))
	GameManager.player_body.modulate.a = 0.2
	GameManager.player_head.modulate.a = 0.2
	get_parent().get_parent().modulate.a = 0.2
	
func Disable_skill():
	GameManager.player.trail.modulate.a = 1.0
	GameManager.player.set_collision_layer(2)
	GameManager.player_body.modulate.a = 1.0
	GameManager.player_head.modulate.a = 1.0
	get_parent().get_parent().modulate.a = 1.0
	get_tree().call_group("Camera_player", "back_color", Vector4(0.0, 0.0, 0.0, 1.0))

func Do_tween():
	Icon.value = 0
	var tween = create_tween()
	tween.tween_property(
		Icon,
		"value",
		3,
		cooldown_time
	)
