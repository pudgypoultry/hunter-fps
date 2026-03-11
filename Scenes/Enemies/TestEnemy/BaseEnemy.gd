extends CharacterBody3D
class_name BaseEnemy

@export var movement_speed : float = 5.0


#TODO: Clean up
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += Vector3(0,-1,0) * delta
	move_and_slide()
