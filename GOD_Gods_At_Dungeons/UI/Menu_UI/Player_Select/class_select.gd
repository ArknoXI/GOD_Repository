extends Control

@export var start_color: Color = Color.DIM_GRAY

@export_category("Arrays")
@export var Heads:Array = [
	"res://Player/Sprites/GoA/Head/Head_GoA.png",
	"res://Player/Sprites/GoB/Head/Head_GoB.png",
	"res://Player/Sprites/GoL/Head/Head_GoL.png"
]
@export var Color_list = {
	"Dark Gray": Color.DIM_GRAY,
	"Green": Color.GREEN,
	"Blue": Color.BLUE,
	"Red": Color.RED,
	"Yellow": Color.YELLOW,
	"Orange": Color.ORANGE,
	"Pink": Color.PINK,
	"Purple": Color.PURPLE,
	"Gray": Color.GRAY
}

@export_category("Heads")
@export var Head_Face: Sprite2D
@export var Head_Side: Sprite2D
@export var Head_Back: Sprite2D

@export_category("Bodys")
@export var body_face: Sprite2D
@export var body_side: Sprite2D
@export var body_back: Sprite2D

@export_category("Labels")
@export var TITLE: Label
@export var HP: Label
@export var DAMAGE: Label
@export var SPEED: Label
@export var WEAPON: Label
@export var BODY_COLOR: Label

var key = Color_list.keys()
var current_class: int = 0
var current_color: int = 0
var current_weapon = "one"

func _ready():
	body_face.material.set_shader_parameter("color", start_color)
	body_side.material.set_shader_parameter("color", start_color)
	body_back.material.set_shader_parameter("color", start_color)
	for button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(change_body.bind(button.name))
		
func change_body(button):
	set_class(button)
	
func set_class(button):
	if button == "Class_1":
		update_head_index(0)
		update_head()
		TITLE.text = "God Of Ash"
		HP.text = "HP: 100"
		DAMAGE.text = "DAMAGE: 35"
		SPEED.text = "SPEED: 70"
		WEAPON.text = "Staff"
		current_weapon = "one"
		return
	if button == "Class_2":
		update_head_index(1)
		update_head()
		TITLE.text = "Goddess Of Blades"
		HP.text = "HP: 100"
		DAMAGE.text = "DAMAGE: 40"
		SPEED.text = "SPEED: 80"
		WEAPON.text = "Dagger"
		current_weapon = "two"
		return
	if button == "Class_3":
		update_head_index(2)
		update_head()
		TITLE.text = "God Of The Lagoon"
		HP.text = "HP: 110"
		DAMAGE.text = "DAMAGE: 20"
		SPEED.text = "SPEED: 70"
		WEAPON.text = "Horn"
		current_weapon = "three"
		return
	if button == "Start":
		GameManager.texture_path_Head = Heads[current_class]
		GameManager.texture_path_Body = Color_list[key[current_color]]
		GameManager.weapon_type = current_weapon
		TransitionScreen.fade_in("res://Locals/main.tscn", 4)
		return
	if button == "Back":
		TransitionScreen.fade_in("res://Locals/Menu_Screen.tscn", 2)
		return
	if button == "Previous":
		update_body("minus")
		update_body_color()
		return
	if button == "Next":
		update_body("plus")
		update_body_color()
		return

func update_body(value: String):
	if value == "minus":
		current_color -= 1
	if value == "plus":
		current_color += 1
	if current_color == -1:
		current_color = Color_list.size() - 1
	if current_color == Color_list.size():
		current_color = 0
		
func update_body_color():
	BODY_COLOR.text = key[current_color]
	body_back.material.set_shader_parameter("color", Color_list[key[current_color]])
	body_face.material.set_shader_parameter("color", Color_list[key[current_color]])
	body_side.material.set_shader_parameter("color", Color_list[key[current_color]])
		
func update_head_index(classe):
	current_class = classe
	
func update_head():
	Head_Back.texture = load(Heads[current_class])
	Head_Face.texture = load(Heads[current_class])
	Head_Side.texture = load(Heads[current_class])
