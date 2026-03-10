extends BoxContainer

@onready var health_bar : TextureProgressBar  = $HealthBar
@onready var stamina_bar : TextureProgressBar = $StaminaBar
var ammo_label : Label
var charge_label : Label


func show_ui():
	visible = true


func hide_ui():
	visible = false


func update_health(current_health : float):
	# print("Health Updated")
	health_bar.value = current_health


func update_ammo(current_ammo : int, max_ammo : int):
	ammo_label.text = str(current_ammo) + "	/	" + str(max_ammo)


func update_charge(current_charge_percentage : float):
	charge_label.text = str(current_charge_percentage) + "%"


func update_stamina(current_stamina : float, max_stamina : float):
	# print("Stamina Updated")
	stamina_bar.value = current_stamina
