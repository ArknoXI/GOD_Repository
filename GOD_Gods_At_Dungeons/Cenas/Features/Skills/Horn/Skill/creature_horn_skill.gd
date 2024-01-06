extends CharacterBody2D
class_name Clone

@export var figures = [
	"res://Cenas/Features/Skills/Horn/Skill/Creatures_figure/Fish_Bottle.tscn"
	#"res://Cenas/Features/Skills/Horn/Skill/Creatures_figure/Crab.tscn",
	#"res://Cenas/Features/Skills/Horn/Skill/Creatures_figure/Crocodile.tscn",
	#"res://Cenas/Features/Skills/Horn/Skill/Creatures_figure/Penguin.tscn",
	#"res://Cenas/Features/Skills/Horn/Skill/Creatures_figure/Seal.tscn",
	#"res://Cenas/Features/Skills/Horn/Skill/Creatures_figure/Turtle.tscn"
]
@onready var figure = $Figure
@onready var healthBar = $HealthBar/ProgressBar
@onready var timer = $Hit_cooldown
@onready var anim = $AnimationPlayer
@export var Health = 3
@export var duration: int
@export var speed: float = 35
var target = null

func _ready():
	var prefab = load(figures[0])
	var texture = prefab.instantiate()
	figure.add_child(texture)
	healthBar.max_value = Health
	healthBar.value = Health
	await get_tree().create_timer(10).timeout
	$auxanim.stop()
	anim.play("spawn_out")

func _physics_process(_delta):
	if target == null:
		target = GameManager.player
	var _direction = global_position.direction_to(target.global_position)
	var _distance = global_position.distance_to(target.global_position)
	if _direction.x < 0:
		figure.get_child(0).get_child(0).flip_h = true
	elif _direction.x > 0:
		figure.get_child(0).get_child(0).flip_h = false
	if _direction.y > 0:
		figure.z_index = 2
	else:
		figure.z_index = 7
	
	if _distance < 50:
		return
	
	velocity = _direction * speed
	move_and_slide()

func TakeDamage():
	if timer.is_stopped():
		timer.start()
		Health -= 1
		healthBar.value = Health
		do_tween()
		if Health <= 0:
			$auxanim.stop()
			anim.play("spawn_out")

func destroy():
	queue_free()

func do_tween():
	var tween = create_tween()
	tween.tween_method(
		set_active,
		true,
		false,
		0.3
	)
	
func set_active(value):
	$Figure.material.set_shader_parameter("is_active", value)

func _on_vision_body_entered(body):
	if body is Enemy and target == null:
		target = body


func _on_vision_body_exited(body):
	if body is Enemy:
		$Vision.call_deferred("set_monitoring", false)
		await get_tree().create_timer(0.1).timeout
		$Vision.call_deferred("set_monitoring", true)


func _on_attack_timer_timeout():
	$Attack/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.3).timeout
	$Attack/CollisionShape2D.disabled = true


func _on_attack_body_entered(body):
	if body is Enemy:
		body.stats.TakeDamage(2)
