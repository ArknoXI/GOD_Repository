extends CharacterBody2D
class_name Player

var _states_machine

@export_category("Objects")
@onready var stats = $Stats
@export var Ghosting: PackedScene
@export var trail: CPUParticles2D = null
@export var Heal_bar: Control
@onready var GhostTimer = $GhostTimer
@onready var DashTimer = $DashTimer
@onready var Dash = $Dash
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var _animation_tree: AnimationTree = null

@export_category("Variables")
@export var can_dash: bool = true
@export var dashLength = 0.45
@export var _acceleration: float = 0.2
@export var _fricction: float = 0.2
@onready var dash_speed = stats.speed_dash
@onready var speed: float = stats.speed

func _ready() -> void:
	GameManager.player = self
	GameManager.player_head = $TextureHead
	GameManager.player_body = $TextureBody
	$TextureHead.texture = load(GameManager.texture_path_Head)
	$TextureBody.material.set_shader_parameter("color", GameManager.texture_path_Body)
	_states_machine = _animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	move()
	look_to()
	animate()
	GameManager.mouse = get_mouse()
	GameManager.mouse_dir = get_direction()
	move_and_slide()

func look_to() -> void:
	_animation_tree["parameters/idle/blend_position"] = get_direction()
	_animation_tree["parameters/walk/blend_position"] = get_direction()
		
func move() -> void:
	var current_direction: Vector2
	
	var _direction: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	if Input.is_action_just_pressed("dash") and can_dash and _direction != Vector2.ZERO:
		GhostTimer.start()
		get_tree().call_group("Camera_player", "shake", 0.5, 0.15)
		current_direction = _direction
		Heal_bar.ener_bar.value = 0
		Heal_bar.fill_energyBar()
		can_dash = false
		DashTimer.start()
		Dash.Start_Dash(dashLength)
	
	
	if Dash.Is_Dashing():
		velocity += Vector2(current_direction.x * dash_speed, current_direction.y * dash_speed)
	if not Dash.Is_Dashing():
		GhostTimer.stop()
	
	if _direction != Vector2.ZERO:
		#_animation_tree["parameters/idle/blend_position"] = _direction
		#_animation_tree["parameters/walk/blend_position"] = _direction
		trail.emitting = true
		velocity.x = lerp(velocity.x, _direction.normalized().x * speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * speed, _acceleration)
		return
		#_direction.normalized().y
	trail.emitting = false
	velocity.x = lerp(velocity.x, _direction.normalized().x * speed, _fricction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * speed, _fricction)
	
func add_ghost():
	var ghost = Ghosting.instantiate()
	var Flip
	if GameManager.get_direction().x > 0:
		Flip = false
	else:
		Flip = true
	ghost.set_property($TextureHead.texture, $TextureBody.texture, position, $TextureShadow.scale, $TextureShadow.frame, Flip)
	get_tree().current_scene.add_child(ghost)

func animate() -> void:
	if velocity.length() > 30:
		_states_machine.travel("walk")
		return
		
	_states_machine.travel("idle")

func get_direction() -> Vector2:
	return global_position.direction_to(get_mouse())

func get_mouse() -> Vector2:
	return get_global_mouse_position()
	
func _on_ghost_timer_timeout():
	add_ghost()

func _on_dash_timer_timeout():
	can_dash = true
