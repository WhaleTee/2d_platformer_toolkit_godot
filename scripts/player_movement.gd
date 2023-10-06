class_name PlayerMovement extends Node2D

@export_category("Movement Settings")
@export var speed: float = 300
@export var use_acceleration: bool = true
@export var ground_acceleration: float = 52
@export var ground_decceleration: float = 52
@export var ground_turn_speed: float = 80
@export_range(0, 1) var ground_friction: float = .005
@export var air_acceleration: float = 52
@export var air_deceleration: float = 52
@export var air_turn_speed: float = 80


@onready var player: CharacterBody2D = get_parent()


var on_ground: bool
var input_vector_x: float
var desired_velocity_x: float


func _process(_delta):
	handle_input()


func _physics_process(_delta: float):
	on_ground = player.is_on_floor()
	desired_velocity_x = input_vector_x * max(speed, 0)
	handle_physics(_delta)
	player.move_and_slide()


func handle_input():
	input_vector_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")


func handle_physics(_delta: float):
	if use_acceleration:
		run_with_acceleration()
	else:
		if on_ground:
			run_without_acceleration()
		else:
			run_with_acceleration()
	handle_friction()


func run_with_acceleration():
	var speed_change: float
	if input_vector_x != 0:
		if (sign(input_vector_x) != sign(player.velocity.x)):
			speed_change = ground_turn_speed if on_ground else air_turn_speed
		else:
			speed_change = ground_acceleration if on_ground else air_acceleration
	else:
		speed_change = ground_decceleration if on_ground else air_deceleration
	player.velocity.x = move_toward(player.velocity.x, desired_velocity_x, speed_change)


func run_without_acceleration():
	player.velocity.x = desired_velocity_x


func handle_friction():
	if on_ground:
		player.velocity.x = lerp(player.velocity.x, 0.0, ground_friction)
