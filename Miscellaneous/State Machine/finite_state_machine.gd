class_name FiniteStateMachine
extends Node

@export var state: PlayerState

func _ready() -> void:
	change_state(state)
	
func change_state(new_state: PlayerState):
	if state is PlayerState:
		state._exit_state()
	new_state._enter_state()
	state = new_state
