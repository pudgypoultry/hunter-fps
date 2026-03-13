extends ActorComponent
class_name CollisionDamageComponent

@onready var area : Area3D = $Area3D
@onready var hitbox : CollisionShape3D = $Area3D/CollisionShape3D

@export var debug : bool = false
@export var scale_difference : float = 1.1
@export var damage_amount : float = 10.0
@export var cooldown : float = .5
@export var can_be_damaged : bool = false

var recently_collided : bool = false
var collision_timer : float = 0.0
var current_overlaps : Array = []


func _ready() -> void:
	hitbox.shape = actor_reference.find_child("CollisionShape3D").shape.duplicate()
	hitbox.scale *= scale_difference
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)


func _process(delta : float) -> void:
	if recently_collided:
		collision_timer += delta


func _physics_process(delta: float) -> void:
	if collision_timer >= cooldown:
		recently_collided = false
		collision_timer = 0.0
		if len(current_overlaps) > 0:
			check_current_overlaps()


func check_current_overlaps() -> void:
	for current_area in current_overlaps:
		_on_area_entered(current_area, true)


func _on_area_entered(current_area : Area3D, repeating : bool = false):
	if !repeating:
		current_overlaps.append(current_area)
	handle_collision(current_area, damage_amount)


func _on_area_exited(current_area : Area3D):
	current_overlaps.erase(current_area)


func handle_collision(body : Area3D, damage : float):
	# Every collision detection component has a parent Node3D
	var collision_detector = body.get_parent()
	if collision_detector.can_be_damaged && !recently_collided:
		collision_detector.damage_me(damage)
	else:
		if debug:
			print_debug(actor_reference.name + " collided with " + body.name)


func damage_me(damage : float):
	actor_reference.damage_me(damage)
	
