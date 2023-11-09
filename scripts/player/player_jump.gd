class_name PlayerJump extends Node2D

signal preset_applied()

const _default_gravity_scale: float = 1

@export var settings_preset: PlayerJumpPreset

@onready var _player: CharacterBody2D = get_parent()
@onready var _default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jump_height: float = 140
var time_to_apex: float = .5
var _jump_count: int = 1
var _variable_jump: bool = false
var _coyote_time: float = 0
var _jump_buffer: float = .03
var _air_friction: float = 1
var _up_gravity_multiplier: float = 1
var _down_gravity_multiplier: float = 1
var _variable_jump_gravity_multiplier: float = 1
var _on_ground: bool = false
var _desired_jump: bool = false
var _pressing_jump: bool = false
var _currently_jumping: bool = false
var _can_jump_again: bool = false
var _jump_counter: int = 0
var _coyote_time_counter: float = 0
var _jump_buffer_counter: float = 0
var _gravity_multiplier: float = _default_gravity_scale

var _jump_gravity: float:
	get: return (2 * jump_height) / pow(time_to_apex, 2) # calculates as 2h/t² to reach specified height in pixels

var _current_gravity: float:
	get: return _jump_gravity if _player.velocity.y < 0 else _fall_gravity

var _jump_velocity: float:
	get: return -2 * jump_height / time_to_apex # calculates as -2h/t

var _fall_gravity: float:
	get: return _jump_gravity


func _ready() -> void:
	if settings_preset:
		_apply_preset()
		settings_preset.changed.connect(_on_settings_preset_changed)


func _physics_process(delta: float) -> void:
	handle_physics(delta)
	if _desired_jump:
		handle_jump()
	# handle_friction()
	_player.move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
			if event.is_action_pressed("jump"):
				_desired_jump = true
				_pressing_jump = true
			elif event.is_action_released("jump"):
				_pressing_jump = false


func handle_physics(delta: float) -> void:
	_on_ground = _player.is_on_floor()
	handle_jump_buffer(delta)
	handle_coyote_time(delta)
	handle_velocity(delta)
	_player.velocity.y += _current_gravity * delta * _gravity_multiplier


func handle_jump_buffer(delta: float) -> void:
	if _jump_buffer > 0 and _desired_jump:
		_jump_buffer_counter += delta
		if _jump_buffer_counter > _jump_buffer:
			_jump_buffer_counter = 0
			_desired_jump = false


func handle_jump() -> void:
	if _on_ground or (_coyote_time_counter > 0 and _coyote_time_counter < _coyote_time) or _can_jump_again:
		_desired_jump = false
		_currently_jumping = true
		_jump_counter += 1
		_jump_buffer_counter = 0
		_coyote_time_counter = 0
		_can_jump_again = _jump_counter < _jump_count
		if _player.velocity.y < 0:
			_player.velocity.y = min(_jump_velocity - _player.velocity.y, 0)
		else: 
			_player.velocity.y = _jump_velocity
	if _jump_buffer == 0:
		_desired_jump = false


func handle_coyote_time(delta: float) -> void:
	if not _currently_jumping and not _on_ground:
		_coyote_time_counter += delta
	else:
		_coyote_time_counter = 0


func handle_velocity(delta: float) -> void:
	if _player.velocity.y < 0:
		if _on_ground:
			_gravity_multiplier = _default_gravity_scale
		else:
			if _variable_jump:
				if _pressing_jump and _currently_jumping:
					_gravity_multiplier = _up_gravity_multiplier
				else:
					_gravity_multiplier = _up_gravity_multiplier * _variable_jump_gravity_multiplier
			else:
				_gravity_multiplier = _up_gravity_multiplier
	elif _player.velocity.y > 0:
		if _on_ground:
			_gravity_multiplier = _default_gravity_scale
		else:
			_gravity_multiplier = _down_gravity_multiplier
	else:
		if _on_ground:
			_jump_counter = 0
			_currently_jumping = false
		_gravity_multiplier = _default_gravity_scale

func handle_friction() -> void:
	if not _on_ground:
		_player.velocity.y *= _air_friction


func _apply_preset() -> void:
	_air_friction = settings_preset.air_friction
	jump_height = settings_preset.jump_height
	time_to_apex = settings_preset.jump_time_to_apex
	_jump_count = settings_preset.jump_count
	_coyote_time = settings_preset.coyote_time
	_jump_buffer = settings_preset.jump_buffer
	_variable_jump = settings_preset.variable_jump
	_variable_jump_gravity_multiplier = settings_preset.variable_jump_gravity_multiplier
	_up_gravity_multiplier = settings_preset.up_gravity_multiplier
	_down_gravity_multiplier = settings_preset.down_gravity_multiplier
	preset_applied.emit()


func _on_settings_preset_changed() -> void:
	_apply_preset()


func _on_jump_height_slider_value_changed(value: float) -> void:
	jump_height = value


func _on_jump_time_slider_value_changed(value: float) -> void:
	time_to_apex = value