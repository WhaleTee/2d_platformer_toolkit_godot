# Generic current_state machine. Initializes states and delegates engine callbacks to the active current_state.
class_name StateMachine extends Node

# Path to the initial active current_state. We export it to be able to pick the initial current_state in the inspector.
@export var initial_state: State
# The current active current_state. At the start of the game, we get the `initial_state`.
@onready var current_state: State = initial_state

func _ready():
	# Subscribe to the states transitioned signal.
	for child in get_children():
		if child is State:
			child.transitioned.connect(on_transition)

	current_state.enter()

func _unhandled_input(event: InputEvent):
	current_state.handle_input(event)

func _process(delta: float):
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func on_transition(target_state: State, msg: Dictionary = {}):
	if target_state != null && target_state != current_state:
		current_state.exit()
		current_state = target_state
		current_state.enter(msg)
