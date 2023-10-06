class_name PlayerIdleState extends State

@export var animation_player: AnimatedSprite2D
@export var idle_anumation_name: String
@export var walk_state: State

func handle_input(_event: InputEvent):
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	if Input.is_action_pressed("ui_right"):
		transitioned.emit(walk_state)

func enter(_msg := {}):
	animation_player.play(idle_anumation_name)

func exit():
	animation_player.stop()
