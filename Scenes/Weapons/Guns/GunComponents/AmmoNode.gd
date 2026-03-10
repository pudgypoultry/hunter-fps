extends Node
class_name GunComponent

@export var max_ammo : int = 12
@export var current_ammo : int = 12

var can_fire = true
var actor_reference : BaseGun


func _ready():
	actor_reference = get_parent()
	current_ammo = max_ammo


func fire() -> bool:
	if current_ammo > 0:
		return true
	else:
		reload()
		return false


func reload():
	current_ammo = max_ammo
