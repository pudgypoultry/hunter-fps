extends State

@export var movement_speed : float = 5.0
@export var rotation_bounds : float = 89.0
@export var mouse_sensitivity : float = 0.05
@export var jump_force : float = 4.5
@export var num_jumps : int = 4
@export var deceleration : float = 25.0

var jump_counter : int = 0



#func state_process(delta):
	#super(delta)
	#if actor_reference.is_on_floor():
		#change_state("Walking")
	#if Input.is_action_just_pressed("dash") && actor_reference.can_dash:
		#actor_reference.stamina_component.spend_stamina(actor_reference.dash_cost)
		#change_state("Dashing")


func state_physics_process(delta):
	super(delta)
	if actor_reference.is_on_floor() and jump_counter != 0:
		jump_counter = 0
	
	if not actor_reference.is_on_floor():
		actor_reference.velocity += actor_reference.get_gravity() * delta
		
	
	if Input.is_action_just_pressed("jump") and !actor_reference.is_on_floor():
		if jump_counter < num_jumps:
			actor_reference.velocity.y = jump_force
			jump_counter += 1
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (actor_reference.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0, direction.z).normalized()
	if direction:
		actor_reference.velocity.x = direction.x * movement_speed
		actor_reference.velocity.z = direction.z * movement_speed
	else:
		actor_reference.velocity.x = move_toward(actor_reference.velocity.x, 0, delta * deceleration)
		actor_reference.velocity.z = move_toward(actor_reference.velocity.z, 0, delta * deceleration)
	
	actor_reference.move_and_slide()


func state_unhandled_input(event):
	rotation_behavior(event)


func enter_state(old_state : State):
	actor_reference.can_jump = false
	super(old_state)
	if old_state == state_manager.states["Walking"]:
		actor_reference.velocity += actor_reference.global_basis.y * jump_force


func rotation_behavior(event : InputEvent):
	if event is InputEventMouseMotion:
		actor_reference.rotate_y(-event.relative.x * mouse_sensitivity)
		actor_reference.rotation.x += -event.relative.y * mouse_sensitivity
		actor_reference.rotation.x = clampf(actor_reference.rotation.x, deg_to_rad(-rotation_bounds), deg_to_rad(rotation_bounds))
