extends Node2D

var Staff: PackedScene = preload("res://Weapons/Weapons_Prefab/Staff/staff_.tscn")
var Dagger: PackedScene = preload("res://Weapons/Weapons_Prefab/Dagger/dagger_.tscn")
var Horn: PackedScene = preload("res://Weapons/Weapons_Prefab/Horn/horn_.tscn")

var currentWeapon = "one"
func desequip():
	if currentWeapon != null and currentWeapon.name == currentWeapon.name:
			print("Desequipa ", currentWeapon.name)
			currentWeapon.queue_free()

func _ready():
	if GameManager.weapon_type == "one":
		print("Equipou Staff")
		var staff = Staff.instantiate()
		#get_tree().current_scene.add_child(staff)
		self.add_child(staff)
		staff.global_position = global_position
		return
		
	if GameManager.weapon_type == "two":
		print("Equipou adagas")
		var dagger = Dagger.instantiate()
		#get_tree().current_scene.add_child(staff)
		self.add_child(dagger)
		dagger.global_position = global_position + Vector2(-4, 0)
		return
		
	if GameManager.weapon_type == "three":
		print("Equipou horn")
		var horn = Horn.instantiate()
		#get_tree().current_scene.add_child(staff)
		self.add_child(horn)
		horn.global_position = global_position
