class_name CurveSlider extends Control

@export var grabber: CurveGrabber
@export var min_value: float = 0:
	get: return min_value
	set(val):
		if min_value != val:
			min_value = val
			if grabber:
				grabber.path.min_value = val
@export var max_value: float = 100:
	get: return max_value
	set(val):
		if max_value != val:
			max_value = val
			if grabber:
				grabber.path.max_value = val
@export var step: float = 1:
	get: return step
	set(val):
		if step != val:
			step = val
			if grabber:
				grabber.path.step = val
