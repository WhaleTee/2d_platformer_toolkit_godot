class_name PlayerMovementPreset extends Resource

@export var use_acceleration: bool
@export var ground_acceleration: float
@export var ground_deceleration: float
@export_range(0, 1) var ground_friction: float
@export var ground_speed: float
@export var ground_turn_speed: float
@export var air_acceleration: float
@export var air_deceleration: float
@export var air_turn_speed: float