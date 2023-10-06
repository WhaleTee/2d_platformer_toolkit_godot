class_name PlayerWalkState extends State

@export var animation_player: AnimatedSprite2D
@export var run_anumation_name: String

func handle_input(_event: InputEvent):
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func enter(_msg := {}):
	animation_player.play(run_anumation_name)

func exit():
	animation_player.stop()
