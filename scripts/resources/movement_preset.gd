class_name PlayerMovementPreset extends Resource

@export var ground_speed: float:
    get: return ground_speed
    set(val): ground_speed = max(val, 0)
@export var use_acceleration: bool
@export var ground_acceleration: float
@export var ground_deceleration: float
@export var ground_turn_speed: float
@export var air_acceleration: float
@export var air_deceleration: float
@export var air_turn_speed: float