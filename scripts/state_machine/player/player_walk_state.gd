class_name PlayerWalkState extends State

@export var animator: PlayerAnimator
@export var jump_state: State
@export var idle_state: State

func handle_input(_event: InputEvent):
	animator.flip_h = _event.is_action_pressed("move_left")
	if _event.is_action_pressed("jump"):
		transition_to.emit(jump_state)
	if not _event.is_action_pressed("move_left") and not _event.is_action_pressed("move_right"):
		transition_to.emit(idle_state)

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func enter(_msg := {}):
	animator.play(animator.animations.walk)

func exit():
	animator.stop()
