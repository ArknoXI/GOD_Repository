extends Camera2D

var Big_State: bool = false
@export var Vignette: ColorRect
#Vector2( 480, 272) Vector2( 688, 384)
var SCREEN_SIZE := Vector2(480, 272)
var current_screen_size: Vector2 = SCREEN_SIZE
var cur_screen := Vector2( 0, 0 )

func _ready():
	set_as_top_level( true )
	global_position = get_parent().global_position
	_update_screen( cur_screen )
	GameManager.dust = $CanvasLayer/DustEffect

func _physics_process(_delta):
	var parent_screen : Vector2 = ( get_parent().global_position / SCREEN_SIZE ).floor()
	if not parent_screen.is_equal_approx( cur_screen ):
		_update_screen( parent_screen )

func _update_screen( new_screen : Vector2 ):
	cur_screen = new_screen
	print(cur_screen)
	global_position = cur_screen * SCREEN_SIZE + SCREEN_SIZE * 0.5

var current_length: float
var current_strength: float

func override_display(new_size:Vector2, new_screen: Vector2):
	zoom = new_size
	SCREEN_SIZE = new_screen
	
func smooth_disable():
	position_smoothing_enabled = not position_smoothing_enabled
	
func shake(_strength: float, _length: float):
	if current_length != 0:
		return
	
	current_length = _length
	current_strength = _strength
	
	while current_length > 0:
		offset = Vector2(
		 randf_range(- current_strength, + current_strength),
		 randf_range(- current_strength, + current_strength)
		)
		current_length -= get_process_delta_time()
		await  get_tree().physics_frame
	offset = Vector2.ZERO
	current_length = 0
	current_strength = 0

func hit_vignette(color):
	hit_tween(color)

func hit_tween(color):
	Vignette.material.set_shader_parameter("vignette_rgb", color)
	
func back_color(color):
	Vignette.material.set_shader_parameter("vignette_rgb", color)
