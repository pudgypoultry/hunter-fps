extends State

@export var dash_speed : float = 20.0
@export var dash_length : float = 0.15
@export var mouse_sensitivity : float = 0.05
@export var rotation_bounds : float = 89.0

var dash_direction : Vector3 = Vector3.FORWARD
var dash_timer : float = 0.0


func enter_state(old_state : State):
	dash_timer = 0.0
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (actor_reference.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if direction.length() == 0:
		dash_direction = -Vector3(actor_reference.global_basis.z.x, 0, actor_reference.global_basis.z.z).normalized()
	else:
		dash_direction = Vector3(direction.x, 0, direction.z).normalized()
	actor_reference.velocity = dash_direction * dash_speed
	await get_tree().create_timer(dash_length).timeout
	if actor_reference.is_on_floor():
		state_manager.change_state(state_manager.states["Walking"])
	else:
		state_manager.change_state(state_manager.states["Jumping"])


func leave_state(new_state : State):
	actor_reference.velocity = Vector3.ZERO


func state_process(delta : float):
	dash_timer += delta


func state_physics_process(delta):
	actor_reference.move_and_slide()


func state_unhandled_input(event):
	rotation_behavior(event)


func rotation_behavior(event : InputEvent):
	if event is InputEventMouseMotion:
		actor_reference.rotate_y(-event.relative.x * mouse_sensitivity)
		actor_reference.rotation.x += -event.relative.y * mouse_sensitivity
		actor_reference.rotation.x = clampf(actor_reference.rotation.x, 
				deg_to_rad(-rotation_bounds), deg_to_rad(rotation_bounds)
			)
