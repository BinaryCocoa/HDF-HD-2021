extends Node2D

var Current_state = null
var previous_state = null
var timer
var states = ["Idle","MoveUp","MoveDown","MoveLeft","MoveRight"]

onready var parent = get_parent()

func _state_logic(delta):
	pass

func _get_transion(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(ncurrent_state):
	pass

func set_state(new_state):
	#previous_state = Current_state
	Current_state = new_state

func _physics_process(delta):
	if Current_state != null:
		_state_logic(delta)
		var transition = _get_transion(delta)
		if transition != null:
			set_state(transition)

func add_state(state_name):
	states.append(state_name)
