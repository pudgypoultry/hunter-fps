extends ActorComponent
class_name StaminaComponent

@export var max_stamina : float = 300.0
@export var recharge_rate : float = 25.0

var current_stamina : float = 300.0

signal stamina_changed(stamina)


func _ready() -> void:
	current_stamina = max_stamina
	if actor_reference is PlayerController:
		player_setup()
	_on_late_ready.call_deferred()


func _on_late_ready() -> void:
	stamina_changed.emit(current_stamina, max_stamina)


func _process(delta: float) -> void:
	if current_stamina < max_stamina:
		current_stamina += recharge_rate * delta
		stamina_changed.emit(current_stamina, max_stamina)


func player_setup() -> void:
	actor_reference.stamina_component = self
	stamina_changed.connect(actor_reference.hud_control.update_stamina)


func spend_stamina(amount : float) -> bool:
	if current_stamina - amount > 0:
		current_stamina -= amount
		stamina_changed.emit(current_stamina, max_stamina)
		return true
	else:
		return false
