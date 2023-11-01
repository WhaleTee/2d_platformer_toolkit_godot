class_name PlayerMovement extends Node2D

@export var settings_preset: PlayerMovementPreset:
	get: return settings_preset
	set(val):
		settings_preset = val
		if settings_preset:
			_apply_preset()
@onready var player: CharacterBody2D = get_parent()

var _speed: float = 100
var _use_acceleration: bool = true
var _ground_acceleration: float = 10
var _ground_decceleration: float = 10
var _ground_turn_speed: float = 10
var _ground_friction: float = 0.015
var _air_acceleration: float = 10
var _air_deceleration: float = 10
var _air_turn_speed: float = 10
var _player_is_on_floor: bool = false
var _input_vector_x: float = 0
var _desired_velocity_x: float = 0


func _ready() -> void:
	if settings_preset:
		_apply_preset()


func _process(_delta) -> void:
	_handle_input()


func _physics_process(_delta: float) -> void:
	_process_movement(_delta)


func _handle_input() -> void:
	_input_vector_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")


func _process_movement(_delta: float) -> void:
	_player_is_on_floor = player.is_on_floor()
	_desired_velocity_x = _input_vector_x * max(_speed, 0)
	if _use_acceleration:
		_run_with_acceleration()
	else:
		if _player_is_on_floor:
			_run_without_acceleration()
		else:
			_run_with_acceleration()
	_apply_friction()
	player.move_and_slide()


func _run_with_acceleration() -> void:
	var speed_change: float
	if _input_vector_x != 0:
		if (sign(_input_vector_x) != sign(player.velocity.x)):
			speed_change = _ground_turn_speed if _player_is_on_floor else _air_turn_speed
		else:
			speed_change = _ground_acceleration if _player_is_on_floor else _air_acceleration
	else:
		speed_change = _ground_decceleration if _player_is_on_floor else _air_deceleration
	player.velocity.x = move_toward(player.velocity.x, _desired_velocity_x, speed_change)


func _run_without_acceleration() -> void:
	player.velocity.x = _desired_velocity_x


func _apply_friction() -> void:
	if _player_is_on_floor:
		player.velocity.x = lerp(player.velocity.x, 0.0, _ground_friction)


func _apply_preset() -> void:
	_speed = settings_preset.ground_speed
	_use_acceleration = settings_preset.use_acceleration
	_ground_acceleration = settings_preset.ground_acceleration
	_ground_decceleration = settings_preset.ground_deceleration
	_ground_turn_speed = settings_preset.ground_turn_speed
	_ground_friction = settings_preset.ground_friction
	_air_acceleration = settings_preset.air_acceleration
	_air_deceleration = settings_preset.air_deceleration
	_air_turn_speed = settings_preset.air_turn_speed



func on_preset_select_button_pressed(preset: PlayerMovementPreset) -> void:
	settings_preset = preset
	_apply_preset()
