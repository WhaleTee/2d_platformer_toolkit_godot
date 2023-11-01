class_name PlayerCameraPreset extends Preset

@export var damping_x: float:
    get: return damping_x
    set(val):
        if damping_x != val:
            damping_x = val
            value_changed.emit("damping_x")
@export var damping_y: float:
    get: return damping_y
    set(val):
        if damping_y != val:
            damping_y = val
            value_changed.emit("damping_y")
@export var lookahead: float:
    get: return lookahead
    set(val):
        if lookahead != val:
            lookahead = val
            value_changed.emit("lookahead")
@export var ignore_jumps: bool:
    get: return ignore_jumps
    set(val):
        if ignore_jumps != val:
            ignore_jumps = val
            value_changed.emit("ignore_jumps")
@export var panic_zone_enable: bool:
    get: return panic_zone_enable
    set(val):
        if panic_zone_enable != val:
            panic_zone_enable = val
            value_changed.emit("panic_zone_enable")
@export var panic_zone: Rect2i:
    get: return panic_zone
    set(val):
        if panic_zone != val:
            panic_zone = val
            value_changed.emit("panic_zone")
@export_range(1.0, 5.0) var panic_speed: float:
    get: return panic_speed
    set(val):
        if panic_speed != val:
            panic_speed = val
            value_changed.emit("panic_speed")