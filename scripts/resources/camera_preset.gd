class_name PlayerCameraPreset extends Resource

@export var locked: bool
@export var damping_x: float
@export var damping_y: float
@export var lookahead: float
@export var ignore_jumps: bool
@export var panic_zone_enable: bool
@export var panic_zone: Rect2i
@export_range(1.0, 5.0) var panic_speed: float
@export var offset: Vector2