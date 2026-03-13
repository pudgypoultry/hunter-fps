extends StateManager

var walk_state : State
var jump_state : State
var dash_state : State

func _ready() -> void:
	super()
	walk_state = states["Walking"]
	jump_state = states["Jumping"]
	dash_state = states["Dashing"]


func _process(delta : float) -> void:
	super(delta)
	_handle_state_transitions(current_state)


func _handle_state_transitions(state):
	match state:
		walk_state:
				if Input.is_action_just_pressed("jump") && actor_reference.can_jump:
					change_state(states["Jumping"])
				if Input.is_action_just_pressed("dash") && actor_reference.can_dash:
					actor_reference.stamina_component.spend_stamina(actor_reference.dash_cost)
					change_state(states["Dashing"])
		jump_state:
				if actor_reference.is_on_floor():
					change_state(states["Walking"])
				if Input.is_action_just_pressed("dash") && actor_reference.can_dash:
					actor_reference.stamina_component.spend_stamina(actor_reference.dash_cost)
					change_state(states["Dashing"])
		dash_state:
			if dash_state.dash_timer > dash_state.dash_length:
				if actor_reference.is_on_floor():
					change_state(states["Walking"])
				else:
					change_state(states["Jumping"])
