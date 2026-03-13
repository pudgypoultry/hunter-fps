extends Node
class_name BaseBullet

@onready var actor_reference : Area3D = get_parent()
@export var direction : Vector3
var prepared : bool = false
var bullet_speed : float
var bullet_lifetime : float = 10.0
var lifetime_timer : float = 0.0


func _ready() -> void:
	GameManager.bullet_list.append(self)


func _physics_process(delta: float) -> void:
	if prepared:
		actor_reference.position += direction * bullet_speed * 0.1
		lifetime_timer += delta
		if lifetime_timer > bullet_lifetime:
			clean_up()


func prepare(dir : Vector3, speed : float, lifetime : float, parent_gun : BaseGun) -> void:
	prepared = true
	direction = dir
	bullet_speed = speed
	bullet_lifetime = lifetime
	actor_reference.body_entered.connect(parent_gun._on_hit.bind(self))


func clean_up():
	actor_reference.queue_free()


func _notification(alert):
	if (alert == NOTIFICATION_PREDELETE):
		GameManager.bullet_list.erase(self)
