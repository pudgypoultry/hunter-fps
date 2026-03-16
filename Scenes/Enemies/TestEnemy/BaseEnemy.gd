extends CharacterBody3D
class_name BaseEnemy

@export var movement_speed : float = 5.0
@export var health_component : HealthComponent
@export var blood_splatter_component : BloodSplatterComponent

var can_be_damaged : bool = true

func _ready() -> void:
	GameManager.enemy_list.append(self)


#TODO: Clean up, move to behavior node
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += Vector3(0,-1,0) * delta
	move_and_slide()


func damage_me(amount, hit_position : Vector3 = position, hit_angle : Vector3 = basis.z) -> bool:
	if can_be_damaged:
		if blood_splatter_component:
			blood_splatter_component.create_splatter(hit_position, hit_angle, 10.0)
		if health_component:
			health_component.damage_me(amount)
			return true
	return false


func _notification(alert):
	if (alert == NOTIFICATION_PREDELETE):
		GameManager.enemy_list.erase(self)
