extends Node2D

@export var creatures: PackedScene
@onready var Icon = $Skill_Icon/HBoxContainer/Skill/TextureProgressBar
@export var Duration = 10
@export var cooldown_time = 2
@export var cooldown: Timer
@export var creature_count: int = 1
var pos = []

func _ready():
	Icon.max_value = cooldown_time
	Icon.value = Icon.max_value
	cooldown.wait_time = cooldown_time
		
func _physics_process(_delta):
	if Input.is_action_just_pressed("Skill_1") and cooldown.is_stopped():
		Active_skill()
		await  get_tree().create_timer(Duration).timeout
		Disable_skill()
		

func Active_skill():
	cooldown.start()
	Do_tween()
	get_pos()
	
func Disable_skill():
	#acaba com a skill
	pass
func get_check_pos(marker, layer):
	var tilemap = get_tree().current_scene.get_node("New_tilemap")
	var coords = tilemap.local_to_map(marker)
	var tile_atlas = tilemap.get_cell_atlas_coords(layer, coords)
	return tile_atlas
	
func get_pos():
	while pos.size() != creature_count:
		var value = randi_range(0, 5)
		if not pos.has(value):
			pos.append(value)
	for p in range(creature_count):
		if get_check_pos($Creatures.get_child(pos[p]).global_position, 4) == Vector2i(-1, -1) or get_check_pos($Creatures.get_child(pos[p]).global_position, 5) == Vector2i(-1, -1):
			var creature = creatures.instantiate()
			get_tree().current_scene.call_deferred("add_child", creature)
			creature.global_position = $Creatures.get_child(pos[p]).global_position
	pos.clear()
		
func Do_tween():
	Icon.value = 0
	var tween = create_tween()
	tween.tween_property(
		Icon,
		"value",
		cooldown_time,
		cooldown_time
	)
