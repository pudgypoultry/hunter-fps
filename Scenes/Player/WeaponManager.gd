extends Node3D
class_name WeaponManager

@export var current_gun : BaseGun
@export var gun_array : Array = []
var player_reference : Node3D
var can_fire : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_reference = get_parent()
	for child in get_children():
		if !(child in gun_array):
			gun_array.append(child)
	for gun in gun_array:
		gun.player_reference = player_reference


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire") && can_fire:
		current_gun.fire()
		can_fire = false


func _on_gun_ready(gun : BaseGun):
	can_fire = true
