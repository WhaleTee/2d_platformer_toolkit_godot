class_name PlayerIdleState extends State

@export var animator: PlayerAnimator
@export var walk_state: State

func handle_input(_event: InputEvent):
	if _event.is_action_pressed("move_left") or _event.is_action_pressed("move_right"):
		transition_to.emit(walk_state)


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func enter(_msg := {}):
	animator.play(animator.animations.idle)


func exit():
	animator.stop()
