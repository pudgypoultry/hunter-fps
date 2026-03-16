extends ActorComponent
class_name BloodSplatterComponent

@export var blood_splatter_decal : PackedScene
@export var blood_textures : Array[Texture2D]

# Provides the parent actor the ability to bleed profusely

func _ready() -> void:
	if actor_reference is BaseEnemy:
		actor_reference.blood_splatter_component = self


func create_splatter(bullet_position : Vector3, direction : Vector3, length : float):
	var collision_point = get_raycast_collision_point(bullet_position, direction, length)
	if collision_point:
		# instantiate decal
		var decal : Decal = blood_splatter_decal.instantiate()
		# load decal with texture
		decal.texture_albedo = blood_textures.pick_random()
		# position on wall within range in direction given
		get_tree().root.add_child(decal)
		decal.position = collision_point
		# decal.look_at(bullet_position)
		decal.scale *= 0.8 + 0.5 * randf()


func get_raycast_collision_point(start_pos: Vector3, direction: Vector3, length: float):
	var space_state = actor_reference.get_world_3d().direct_space_state
	var end_pos = start_pos + (direction.normalized() * length)
	var query = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	var result = space_state.intersect_ray(query)
	
	if not result.is_empty():
		return result["position"]
	return null
