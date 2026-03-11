extends ActorComponent
class_name CollisionDamageComponent

@onready var area : Area3D = $Area3D
@onready var hitbox : CollisionShape3D = $Area3D/CollisionShape3D
@export var valid_collisions : Array
@export var damage_amount : float = 10.0
@export var cooldown : float = .5

var recently_collided : bool = false
var collision_timer : float = 0.0

func _ready() -> void:
	hitbox.shape = actor_reference.find_child("CollisionShape3D").shape.duplicate()
	hitbox.scale *= 1.1
	area.body_entered.connect(_on_body_entered)


func _process(delta : float) -> void:
	if recently_collided:
		collision_timer += delta
		if collision_timer >= cooldown:
			recently_collided = false
			collision_timer = 0.0
			check_current_overlaps()


func _on_body_entered(body):
	if body is PlayerController:
		body.damage_player(damage_amount)
		recently_collided = true
	else:
		print(body.name + " says hi")


func check_current_overlaps() -> void:
	var overlapping_bodies = area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is CharacterBody3D:
			print("Currently overlapping with stationary or moving body: ", body.name)
			_on_body_entered(body)
