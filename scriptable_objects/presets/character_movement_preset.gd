class_name CharacterMovementPreset extends DataHolder

const VarName = {
	ground_acceleration = "ground_acceleration",
	ground_deceleration = "ground_deceleration",
	ground_friction = "ground_friction",
	ground_speed = "ground_speed",
	ground_turn_speed = "ground_turn_speed",
	air_acceleration = "air_acceleration",
	air_deceleration = "air_deceleration",
	air_friction = "air_friction",
	air_turn_speed = "air_turn_speed",
	jump_count = "jump_count",
	jump_height = "jump_height",
	jump_time_to_apex = "jump_time_to_apex",
	variable_jump = "variable_jump",
	variable_jump_gravity_multiplier = "variable_jump_gravity_multiplier",
	up_gravity_multiplier = "up_gravity_multiplier",
	down_gravity_multiplier = "down_gravity_multiplier"
}

@export var ground_acceleration: float:
	get:
		return ground_acceleration
	set(new_ground_acceleration):
		set_value(VarName.ground_acceleration, new_ground_acceleration)
@export var ground_deceleration: float:
	get:
		return ground_deceleration
	set(new_ground_deceleration):
		set_value(VarName.ground_deceleration, new_ground_deceleration)
@export var ground_friction: float:
	get:
		return ground_friction
	set(new_ground_friction):
		set_value(VarName.ground_friction, new_ground_friction)
@export var ground_speed: float:
	get:
		return ground_speed
	set(new_ground_speed):
		set_value(VarName.ground_speed, new_ground_speed)
@export var ground_turn_speed: float:
	get:
		return ground_turn_speed
	set(new_ground_turn_speed):
		set_value(VarName.ground_turn_speed, new_ground_turn_speed)

@export var air_acceleration: float:
	get:
		return air_acceleration
	set(new_air_acceleration):
		set_value(VarName.air_acceleration, new_air_acceleration)
@export var air_deceleration: float:
	get:
		return air_deceleration
	set(new_air_deceleration):
		set_value(VarName.air_deceleration, new_air_deceleration)
@export var air_turn_speed: float:
	get:
		return air_turn_speed
	set(new_air_turn_speed):
		set_value(VarName.air_turn_speed, new_air_turn_speed)
@export var air_friction: float:
	get:
		return air_friction
	set(new_air_friction):
		set_value(VarName.air_friction, new_air_friction)
@export var jump_count: int:
	get:
		return jump_count
	set(new_jump_count):
		set_value(VarName.jump_count, new_jump_count)
@export var jump_height: float:
	get:
		return jump_height
	set(new_jump_height):
		set_value(VarName.jump_height, new_jump_height)
@export var jump_time_to_apex: float:
	get:
		return jump_time_to_apex
	set(new_jump_time_to_apex):
		set_value(VarName.jump_time_to_apex, new_jump_time_to_apex)
@export var variable_jump: bool:
	get:
		return variable_jump
	set(new_variable_jump):
		set_value(VarName.variable_jump, new_variable_jump)
@export var variable_jump_gravity_multiplier: float:
	get:
		return variable_jump_gravity_multiplier
	set(new_variable_jump_gravity_multiplier):
		set_value(VarName.variable_jump_gravity_multiplier, new_variable_jump_gravity_multiplier)
@export var up_gravity_multiplier: float:
	get:
		return up_gravity_multiplier
	set(new_up_gravity_multiplier):
		set_value(VarName.up_gravity_multiplier, new_up_gravity_multiplier)
@export var down_gravity_multiplier: float:
	get:
		return down_gravity_multiplier
	set(new_down_gravity_multiplier):
		set_value(VarName.down_gravity_multiplier, new_down_gravity_multiplier)


func _init() -> void:
	put_data_info(VarName.ground_acceleration, DataHolderVarInfo.new())
	put_data_info(VarName.ground_deceleration, DataHolderVarInfo.new())
	put_data_info(VarName.ground_speed, DataHolderVarInfo.new())
	put_data_info(VarName.ground_turn_speed, DataHolderVarInfo.new())
	put_data_info(VarName.air_acceleration, DataHolderVarInfo.new())
	put_data_info(VarName.air_deceleration, DataHolderVarInfo.new())
	put_data_info(VarName.air_turn_speed, DataHolderVarInfo.new())
	put_data_info(VarName.jump_height, DataHolderVarInfo.new())
	put_data_info(VarName.jump_time_to_apex, DataHolderVarInfo.new())
	put_data_info(VarName.variable_jump, DataHolderVarInfo.new())
	put_data_info(VarName.variable_jump_gravity_multiplier, DataHolderVarInfo.new())
	put_data_info(VarName.jump_count, DataHolderVarInfo.new())
	put_data_info(VarName.up_gravity_multiplier, DataHolderVarInfo.new())


func set_value(name: String, value) -> void:
	if can_update_data_after_load:
		set(name, value)
	elif not get_data_info(name).is_data_set:
		set(name, value)
	get_data_info(name).is_data_set = true
