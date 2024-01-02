extends Node2D

@export var Prefab_dagger: PackedScene
@export var is_active: bool = false
@onready var Icon = $Skill_Icon/HBoxContainer/Supreme/TextureProgressBar
@onready var anim = $Anim
@export var Duration = 10
@export var cooldown_time = 30
@export var cooldown: Timer

func _ready():
	Icon.max_value = cooldown_time
	cooldown.wait_time = cooldown_time
		
func _physics_process(_delta):
	if Input.is_action_just_pressed("Supreme") and cooldown.is_stopped():
		print("Oie")
		Active_skill()
		await  get_tree().create_timer(Duration).timeout
		Disable_skill()
		

func Active_skill():
	is_active = true
	cooldown.start()
	Do_tween()
	anim.play("roll")
	for i in $Wings.get_child_count():
		await get_tree().create_timer(0.1).timeout
		var projectile = Prefab_dagger.instantiate()
		$Wings.get_child(i).call_deferred("add_child", projectile)
		
	
func reset():
	if not is_active:
		return
	for i in $Wings.get_child_count():
		await get_tree().create_timer(0.1).timeout
		if $Wings.get_child(i).get_child_count() == 0:
			var projectile = Prefab_dagger.instantiate()
			$Wings.get_child(i).call_deferred("add_child", projectile)
			
func destroy():
	for i in $Wings.get_child_count():
		await get_tree().create_timer(0.1).timeout
		if $Wings.get_child(i).get_child_count() > 0:
			$Wings.get_child(i).get_child(0).queue_free()
	
func Disable_skill():
	is_active = false
	await get_tree().create_timer(5).timeout
	destroy()

func Do_tween():
	Icon.value = 0
	var tween = create_tween()
	tween.tween_property(
		Icon,
		"value",
		cooldown_time,
		cooldown_time
	)
