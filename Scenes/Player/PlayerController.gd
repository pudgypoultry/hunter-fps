extends CharacterBody3D
class_name PlayerController

@export var hud_control : Control
@export var movement_state_manager : StateManager
@export var action_state_manager : StateManager
@export var camera : Camera3D

var dash_cost : float = 100.0

var can_jump : bool = true
var can_dash : bool = true
var can_shoot : bool = true
var can_be_damaged : bool = true

var health_component : HealthComponent
var stamina_component : StaminaComponent
var hud_ammo : Control
var hud_charge : Control

var has_weapon_ammo_component_equipped : bool = false
var has_weapon_charge_component_equipped : bool = false


func _ready() -> void:
	GameManager.player_reference = self


func _process(delta : float) -> void:
	if stamina_component.current_stamina >= dash_cost:
		can_dash = true
	else:
		can_dash = false 


func damage_me(amount) -> bool:
	if can_be_damaged:
		if health_component:
			health_component.damage_me(amount)
			return true
	return false


func spend_stamina(amount) -> void:
	if stamina_component:
		stamina_component.spend_stamina(amount)


func kill_me() -> void:
	print("I should be dead")


#func setup_ui() -> void:
	#health_component.setup()
	#stamina_component.setup()
