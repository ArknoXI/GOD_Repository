extends Node2D

@export var Prefab_horn: PackedScene
@export var is_active: bool = false
@onready var Icon = $Skill_Icon/HBoxContainer/Supreme/TextureProgressBar
@export var Duration: float
@export var cooldown_time: float
@export var cooldown: Timer
@export var cor: Color

var connect_wall = []

var wall_list = [
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(8,0),
	Vector2i(9,0),
	Vector2i(10,0),
	Vector2i(0,1),
	Vector2i(1,1),
	Vector2i(2,1),
	Vector2i(3,1),
	Vector2i(8,1),
	Vector2i(9,1),
	Vector2i(10,1),
	Vector2i(0,2),
	Vector2i(1,2),
	Vector2i(2,2),
	Vector2i(3,2),
	Vector2i(8,2),
	Vector2i(9,2),
	Vector2i(10,2),
	]

func _ready():
	Icon.max_value = cooldown_time
	Icon.value = cooldown_time
	cooldown.wait_time = cooldown_time
		
func _physics_process(_delta):
	if Input.is_action_just_pressed("Supreme") and cooldown.is_stopped():
		Active_skill()
		await  get_tree().create_timer(Duration).timeout
		get_tree().current_scene.get_node("Rain_supreme").is_active = false
		await  get_tree().create_timer(1.15).timeout
		Disable_skill()
		
func Active_skill():
	cooldown.start()
	Do_tween()
	generate_cells()
	GameManager.dust.color = Color.AQUA
	GameManager.player.trail.modulate.a = 0
	var area = Prefab_horn.instantiate()
	area.is_active = true
	get_tree().current_scene.call_deferred("add_child", area)
	area.global_position = GameManager.player.global_position
	
func Disable_skill():
	var tilemap: TileMap = get_tree().current_scene.get_node("New_tilemap")
	layer_modulate(tilemap)
	GameManager.Cells_position.clear()
	GameManager.player.trail.modulate.a = 1
	GameManager.dust.color = Color.FIREBRICK
	get_tree().current_scene.get_node("Rain_supreme").queue_free()
	
func generate_cells():
	var Height = 7
	var tilemap: TileMap = get_tree().current_scene.get_node("New_tilemap")
	var coords_inicial = tilemap.local_to_map(GameManager.player.global_position)
	#var teste = tilemap.map_to_local(coords_inicial)
	generate_up(tilemap, coords_inicial, Height)
	generate_down(tilemap, coords_inicial, Height)
	
func generate_down(tilemap, coords_inicial, Height):
	for H in range(0, -Height - 1, -1):
		await get_tree().create_timer(0.1).timeout
		if H == -Height or H == Height:
			get_array_cells(tilemap, coords_inicial, 2, H)
		if H == -Height + 1 or H == Height - 1:
			get_array_cells(tilemap, coords_inicial, 4, H)
		if H == -Height + 2 or H == Height - 2:
			get_array_cells(tilemap, coords_inicial, 5, H)
		if H == -Height + 3 or H == -Height + 4 or H == Height - 3 or H == Height - 4:
			get_array_cells(tilemap, coords_inicial, 6, H)
		if H >= -2 and H <= 2:
			get_array_cells(tilemap, coords_inicial, 7, H)

func generate_up(tilemap, coords_inicial, Height):
	for H in range(0,Height + 1):
		await get_tree().create_timer(0.1).timeout
		if H == -Height or H == Height:
			get_array_cells(tilemap, coords_inicial, 2, H)
		if H == -Height + 1 or H == Height - 1:
			get_array_cells(tilemap, coords_inicial, 4, H)
		if H == -Height + 2 or H == Height - 2:
			get_array_cells(tilemap, coords_inicial, 5, H)
		if H == -Height + 3 or H == -Height + 4 or H == Height - 3 or H == Height - 4:
			get_array_cells(tilemap, coords_inicial, 6, H)
		if H >= -2 and H <= 2:
			get_array_cells(tilemap, coords_inicial, 7, H)
			
func generate_right(tilemap, inicial_, Largura, Altura):
	for i in range(0, -Largura - 1, -1):
		var coords = Vector2i(inicial_.x - i, inicial_.y - Altura)
		var tile_coords: Array = [
			tilemap.get_cell_atlas_coords(1, coords),
			tilemap.get_cell_atlas_coords(4, coords),
			tilemap.get_cell_atlas_coords(5, coords)
		]
		if tile_coords.all(get_tile_coords):
			continue
		if not wall_list.has(tile_coords[1]) and not wall_list.has(tile_coords[2]):
			connect_wall.append(coords)

func generate_left(tilemap, inicial_, Largura, Altura):
	for i in range(1, Largura + 1):
		var coords = Vector2i(inicial_.x - i, inicial_.y - Altura)
		var tile_coords: Array = [
			tilemap.get_cell_atlas_coords(1, coords),
			tilemap.get_cell_atlas_coords(4, coords),
			tilemap.get_cell_atlas_coords(5, coords)
		]
		if tile_coords.all(get_tile_coords):
			continue
		if not wall_list.has(tile_coords[1]) and not wall_list.has(tile_coords[2]):
			connect_wall.append(coords)

func get_tile_coords(number):
	return number == Vector2i(-1, -1)
func get_array_cells(tilemap, inicial_, Largura, Altura):
	generate_right(tilemap, inicial_, Largura, Altura)
	generate_left(tilemap, inicial_, Largura, Altura)
	var cells = []
	cells.append_array(connect_wall)
	set_cells_connect(tilemap, cells)
	get_array_cells_position(tilemap, cells)
	connect_wall.clear()

func get_array_cells_position(tilemap, cells: Array):
	var pos_cells = []
	for c in cells.size():
		pos_cells.append(tilemap.map_to_local(cells[c]))
	GameManager.Cells_position.append_array(pos_cells)

func set_cells_connect(tilemap, Cells_coords):
	tilemap.set_cells_terrain_connect(2, Cells_coords, 0, 0, false)
	tilemap.set_cells_terrain_connect(3, Cells_coords, 0, 1)

func layer_modulate(tilemap):
	var tween = create_tween()
	tween.parallel().tween_property(
		tilemap,
		"layer_2/modulate",
		cor,
		1
	)
	tween.parallel().tween_property(
		tilemap,
		"layer_3/modulate",
		cor,
		1
	)
	await tween.finished
	tilemap.clear_layer(2)
	tilemap.clear_layer(3)
	tilemap.set_layer_modulate(2, Color.WHITE)
	tilemap.set_layer_modulate(3, Color.WHITE)
	
func Do_tween():
	Icon.value = 0
	var tween = create_tween()
	tween.tween_property(
		Icon,
		"value",
		cooldown_time,
		cooldown_time
	)
