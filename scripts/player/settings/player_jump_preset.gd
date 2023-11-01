class_name PlayerJumpPreset extends Preset

@export_range(0, 1) var air_friction: float:
    get: return air_friction
    set(val):
        if air_friction != val:
            air_friction = val
            value_changed.emit("air_friction")
@export var jump_height: float:
    get: return jump_height
    set(val):
        if jump_height != val:
            jump_height = val
            value_changed.emit("jump_height")
@export var jump_time_to_apex: float:
    get: return jump_time_to_apex
    set(val):
        if jump_time_to_apex != val:
            jump_time_to_apex = val
            value_changed.emit("time_to_apex")
@export var jump_count: int:
    get: return jump_count
    set(val):
        if jump_count != val:
            jump_count = val
            value_changed.emit("jump_count")
@export var coyote_time: float:
    get: return coyote_time
    set(val):
        if coyote_time != val:
            coyote_time = val
            value_changed.emit("coyote_time")
@export var jump_buffer: float:
    get: return jump_buffer
    set(val):
        if jump_buffer != val:
            jump_buffer = val
            value_changed.emit("jump_buffer")
@export var variable_jump: bool:
    get: return variable_jump
    set(val):
        if variable_jump != val:
            variable_jump = val
            value_changed.emit("variable_jump")
@export var variable_jump_gravity_multiplier: float:
    get: return variable_jump_gravity_multiplier
    set(val):
        if variable_jump_gravity_multiplier != val:
            variable_jump_gravity_multiplier = val
            value_changed.emit("variable_jump_gravity_multiplier")
@export var up_gravity_multiplier: float:
    get: return up_gravity_multiplier
    set(val):
        if up_gravity_multiplier != val:
            up_gravity_multiplier = val
            value_changed.emit("up_gravity_multiplier")
@export var down_gravity_multiplier: float:
    get: return down_gravity_multiplier
    set(val):
        if down_gravity_multiplier != val:
            down_gravity_multiplier = val
            value_changed.emit("down_gravity_multiplier")