class_name CurveSlider extends Control

@export var grabber: CurveGrabber
@export var min_value: float = 0
@export var max_value: float = 100
@export var step: float = 1


func _ready() -> void:
	grabber.path.min_value = min_value
	grabber.path.max_value = max_value
	grabber.path.step = step
