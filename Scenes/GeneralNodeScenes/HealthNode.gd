extends ActorComponent
class_name HealthComponent

@export var max_health : float = 100.0
@export var mitigation_ratio : float = 0.9

var current_health : float = 100.0

signal health_changed(health)


func _ready() -> void:
	current_health = max_health
	if actor_reference is PlayerController:
		player_setup()
	_on_late_ready.call_deferred()


func _on_late_ready() -> void:
	health_changed.emit(current_health)


func player_setup() -> void:
	actor_reference.health_component = self
	health_changed.connect(actor_reference.hud_control.update_health)


func damage_me(amount : float) -> void:
	current_health -= amount * mitigation_ratio
	print("	" + str(current_health))
	if current_health > 0:
		health_changed.emit(current_health)
	else:
		health_changed.emit(0.0)
		actor_reference.kill_me()
