class_name PlayerJumpPreset extends Resource

@export var air_friction: float:
    set(val):
        if val != air_friction:
            air_friction = val
            changed.emit()
@export var jump_height: float:
    set(val):
        if val != jump_height:
            jump_height = val
            changed.emit()
@export var jump_time_to_apex: float:
    set(val):
        if val != jump_time_to_apex:
            jump_time_to_apex = val
            changed.emit()
@export var jump_count: int:
    set(val):
        if val != jump_count:
            jump_count = val
            changed.emit()
@export var coyote_time: float:
    set(val):
        if val != coyote_time:
            coyote_time = val
            changed.emit()
@export var jump_buffer: float:
    set(val):
        if val != jump_buffer:
            jump_buffer = val
            changed.emit()
@export var variable_jump: bool:
    set(val):
        if val != variable_jump:
            variable_jump = val
            changed.emit()
@export var variable_jump_gravity_multiplier: float:
    set(val):
        if val != variable_jump_gravity_multiplier:
            variable_jump_gravity_multiplier = val
            changed.emit()
@export var up_gravity_multiplier: float:
    set(val):
        if val != up_gravity_multiplier:
            up_gravity_multiplier = val
            changed.emit()
@export var down_gravity_multiplier: float:
    set(val):
        if val != down_gravity_multiplier:
            down_gravity_multiplier = val
            changed.emit()

@export var air_acceleration: float:
    set(val):
        if val != air_acceleration:
            air_acceleration = val
            changed.emit()
@export var air_deceleration: float:
    set(val):
        if val != air_deceleration:
            air_deceleration = val
            changed.emit()