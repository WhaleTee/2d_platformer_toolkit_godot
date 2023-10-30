class_name PlayerJump extends Node2D

const default_gravity_scale: float = 1

@export_category("Jump Settings")
@export var jump_height: float = 140
@export var time_to_apex: float = .5
@export var jump_count: int = 1
@export var variable_jump: bool = false
@export_range(0, .3) var coyote_time: float = 0
@export_range(0, .3) var jump_buffer: float = .03
@export_category("Gravity Settings")
@export_range(0, 1) var air_friction: float = .005
@export_range(1, 10) var up_gravity_multiplier: float = 1
@export_range(1, 10) var down_gravity_multiplier: float = 1
@export_range(1, 10) var variable_jump_gravity_multiplier: float = 1

@onready var player: CharacterBody2D = get_parent()
@onready var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var on_ground: bool = false
var desired_jump: bool = false
var pressing_jump: bool = false
var currently_jumping: bool = false
var can_jump_again: bool = false
var jump_counter: int = 0
var coyote_time_counter: float = 0
var jump_buffer_counter: float = 0
var gravity_multiplier: float = default_gravity_scale
var jump_gravity: float:
	get: return (4 * jump_height) / pow(time_to_apex, 2) # calculates as 4h/t² to reach specified height in pixels
	set(_val): pass
var current_gravity: float:
	get: return jump_gravity if player.velocity.y < 0 else default_gravity
	set(_val): pass
var jump_velocity: float:
	get: return -2 * jump_height / time_to_apex
	set(_val): pass


func _physics_process(_delta: float):
	handle_physics(_delta)
	if desired_jump:
		handle_jump()
	handle_friction()
	player.move_and_slide()


func _input(_event: InputEvent):
	if _event is InputEventKey:
			if _event.is_action_pressed("jump"):
				desired_jump = true
				pressing_jump = true
			elif _event.is_action_released("jump"):
				pressing_jump = false


func handle_physics(_delta: float):
	on_ground = player.is_on_floor()
	handle_jump_buffer(_delta)
	handle_coyote_time(_delta)
	handle_velocity(_delta)
	player.velocity.y += current_gravity * _delta * gravity_multiplier


func handle_jump_buffer(_delta: float):
	if jump_buffer > 0 and desired_jump:
		jump_buffer_counter += _delta
		if jump_buffer_counter > jump_buffer:
			jump_buffer_counter = 0
			desired_jump = false


func handle_jump():
	if on_ground or (coyote_time_counter > 0 and coyote_time_counter < coyote_time) or can_jump_again:
		desired_jump = false
		currently_jumping = true
		jump_counter += 1
		jump_buffer_counter = 0
		coyote_time_counter = 0
		can_jump_again = jump_counter < jump_count
		if player.velocity.y < 0:
			player.velocity.y = min(jump_velocity - player.velocity.y, 0)
		else: 
			player.velocity.y = jump_velocity
	if jump_buffer == 0:
		desired_jump = false


func handle_coyote_time(_delta: float):
	if not currently_jumping and not on_ground:
		coyote_time_counter += _delta
	else:
		coyote_time_counter = 0


func handle_velocity(_delta: float):
	if player.velocity.y < 0:
		if on_ground:
			gravity_multiplier = default_gravity_scale
		else:
			if variable_jump:
				if pressing_jump and currently_jumping:
					gravity_multiplier = up_gravity_multiplier
				else:
					gravity_multiplier = up_gravity_multiplier * variable_jump_gravity_multiplier
			else:
				gravity_multiplier = up_gravity_multiplier
	elif player.velocity.y > 0:
		if on_ground:
			gravity_multiplier = default_gravity_scale
		else:
			gravity_multiplier = down_gravity_multiplier
	else:
		if on_ground:
			jump_counter = 0
			currently_jumping = false
		gravity_multiplier = default_gravity_scale

func handle_friction():
	if not on_ground:
		player.velocity.y = lerp(player.velocity.y, 0.0, air_friction)
