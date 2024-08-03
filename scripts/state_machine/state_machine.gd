extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		current_state = initial_state
		current_state.state_enter()


func _process(delta):
	if current_state:
		current_state.state_update(delta)


func _physics_process(delta):
	if current_state:
		current_state.state_physics_update(delta)


func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Clean up the previous state
	if current_state:
		current_state.state_exit()
	
	# Intialize the new state
	new_state.state_enter()
	current_state = new_state
