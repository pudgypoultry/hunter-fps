extends CharacterBody3D
class_name BaseEnemy

@export var movement_speed : float = 5.0
@export var health_component : HealthComponent

var can_be_damaged : bool = true

func _ready() -> void:
	GameManager.enemy_list.append(self)


#TODO: Clean up, move to behavior node
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += Vector3(0,-1,0) * delta
	move_and_slide()


func damage_me(amount) -> bool:
	if can_be_damaged:
		if health_component:
			health_component.damage_me(amount)
			return true
	return false


func _notification(alert):
	if (alert == NOTIFICATION_PREDELETE):
		GameManager.enemy_list.erase(self)
