extends Control

@export_category("Arrays")
@export var Heads:Array = [
	"res://Player/Sprites/GoA/Head/Head_GoA.png",
	"res://Player/Sprites/GoB/Head/Head_GoB.png",
	"res://Player/Sprites/GoL/Head/Head_GoL.png"
]

@export var Bodys:Array = [
	"res://Player/Sprites/Body_Colors/Style_01/Body_Gray.png",
	"res://Player/Sprites/Body_Colors/Style_01/Body_Green.png",
	"res://Player/Sprites/Body_Colors/Style_01/Body_Blue.png"
]

@export var color_list:Array = [
	"Gray",
	"Green",
	"Blue"
]

@export_category("Heads")
@export var Head_Face: Sprite2D
@export var Head_Side: Sprite2D
@export var Head_Back: Sprite2D

@export_category("Bodys")
@export var Body_Face: Sprite2D
@export var Body_Side: Sprite2D
@export var Body_Back: Sprite2D

@export_category("Labels")
@export var TITLE: Label
@export var HP: Label
@export var DAMAGE: Label
@export var SPEED: Label
@export var WEAPON: Label
@export var BODY_COLOR: Label

var current_class: int = 0
var current_body_id = 0
var current_weapon = "one"

func _ready():
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
		GameManager.texture_path_Body = Bodys[current_body_id]
		GameManager.weapon_type = current_weapon
		TransitionScreen.fade_in("res://Locals/main.tscn", 4)
		return
	if button == "Back":
		TransitionScreen.fade_in("res://Locals/Menu_Screen.tscn", 2)
		return
	if button == "Previous":
		update_index("minus")
		update_body()
		return
	if button == "Next":
		update_index("plus")
		update_body()
		return
		
func update_index(type:String):
	if type == "minus":
		current_body_id -= 1
		
	if type == "plus":
		current_body_id += 1
		
	if current_body_id == -1:
		current_body_id = Bodys.size() - 1 
		
	if current_body_id == Bodys.size():
		current_body_id = 0
func update_head_index(classe):
	current_class = classe
	
func update_head():
	Head_Back.texture = load(Heads[current_class])
	Head_Face.texture = load(Heads[current_class])
	Head_Side.texture = load(Heads[current_class])
	
func update_body():
	BODY_COLOR.text = color_list[current_body_id]
	Body_Back.texture = load(Bodys[current_body_id])
	Body_Face.texture = load(Bodys[current_body_id])
	Body_Side.texture = load(Bodys[current_body_id])
