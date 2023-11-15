class_name PlayerMovement extends CharacterBody2D

@export var movement_preset: PlayerMovementPreset = PlayerMovementPreset.new()
@export var jump_preset: PlayerJumpPreset = PlayerJumpPreset.new()

const _default_gravity_scale: float = 1
var _input_vector_x: float = 0
var _desired_velocity_x: float = 0
var _on_ground: bool = false
var _desired_jump: bool = false
var _pressing_jump: bool = false
var _currently_jumping: bool = false
var _can_jump_again: bool = false
var _jump_counter: int = 0
var _coyote_time_counter: float = 0
var _jump_buffer_counter: float = 0
var _jump_gravity: float:
	get: return 2 * jump_preset.jump_height / jump_preset.time_to_apex ** 2
var _current_gravity: float:
	get:
		var multiplier: float = _default_gravity_scale
		if (
			jump_preset.variable_jump
			&& velocity.y < 0
			&& !_on_ground
			&& (!_pressing_jump || !_currently_jumping)
		):
			multiplier = jump_preset.variable_jump_gravity_multiplier
		return (_jump_gravity if velocity.y < 0 else _fall_gravity) * multiplier
var _jump_init_velocity: float:
	get: return -_jump_gravity * jump_preset.time_to_apex
var _fall_gravity: float:
	get: return 2 * jump_preset.jump_height / jump_preset.time_to_floor ** 2


func _physics_process(delta: float) -> void:
	_update_state(delta)
	_process_movement(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("jump"):
			_desired_jump = true
			_pressing_jump = true
		elif event.is_action_released("jump"):
			_pressing_jump = false
	_input_vector_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")


func _update_state(delta: float) -> void:
	_on_ground = is_on_floor()
	_desired_velocity_x = _input_vector_x * max(movement_preset.ground_speed, 0)
	_update_jump_buffer(delta)
	_update_coyote_time(delta)
	_update_jump_state(delta)


func _update_jump_buffer(delta: float) -> void:
	if jump_preset.jump_buffer_time > 0 && _desired_jump:
		_jump_buffer_counter += delta
		if _jump_buffer_counter > jump_preset.jump_buffer_time:
			_jump_buffer_counter = 0
			_desired_jump = false


func _update_coyote_time(delta: float) -> void:
	if !_currently_jumping && !_on_ground:
		_coyote_time_counter += delta
	else:
		_coyote_time_counter = 0


func _update_jump_state(delta: float) -> void:
	if _on_ground && velocity.y != 0:
		_jump_counter = 0
		_currently_jumping = false


func _process_movement(delta: float) -> void:
	_horizontal_movement()
	_vertical_movement(delta)


func _horizontal_movement() -> void:
	if movement_preset.use_acceleration || !_on_ground:
		_run_with_acceleration()
	else:
		_run_without_acceleration()


func _run_with_acceleration() -> void:
	var speed_change: float
	if _input_vector_x != 0:
		if (sign(_input_vector_x) != sign(velocity.x)):
			speed_change = movement_preset.ground_turn_speed if _on_ground else movement_preset.air_turn_speed
		else:
			speed_change = movement_preset.ground_acceleration if _on_ground else movement_preset.air_acceleration
	else:
		speed_change = movement_preset.ground_decceleration if _on_ground else movement_preset.air_deceleration
	velocity.x = move_toward(velocity.x, _desired_velocity_x, speed_change)


func _run_without_acceleration() -> void:
	velocity.x = _desired_velocity_x


func _vertical_movement(delta: float) -> void:
	if _desired_jump:
		_jump()
		# apply half of the jump gravity to correct jump height
		velocity.y += _current_gravity * delta * .5
	else:
		velocity.y += _current_gravity * delta


func _jump() -> void:
	if _on_ground || (_coyote_time_counter > 0 && _coyote_time_counter < jump_preset.coyote_time) || _can_jump_again:
		_desired_jump = false
		_currently_jumping = true
		_jump_counter += 1
		_jump_buffer_counter = 0
		_coyote_time_counter = 0
		_can_jump_again = _jump_counter < jump_preset.jump_count
		_apply_jump_initial_velocity()
	if jump_preset.jump_buffer_time == 0:
		_desired_jump = false


func _apply_jump_initial_velocity() -> void:
	if velocity.y < 0: # jump in the air
		velocity.y = min(_jump_init_velocity - velocity.y, 0)
	else: 
		velocity.y = _jump_init_velocity


func _on_jump_height_value_changed(val: float) -> void:
	jump_preset.jump_height = val


func _on_time_to_apex_value_changed(val: float) -> void:
	jump_preset.time_to_apex = val


func _on_time_to_floor_value_changed(val: float) -> void:
	jump_preset.time_to_floor = val
