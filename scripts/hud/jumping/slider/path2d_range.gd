@tool
class_name Path2DRange extends Path2D

signal value_changed(value: float)

@export var value: float:
	set(val):
		val = _get_value_with_step(val, min_value, max_value, step)
		if value != val:
			value = val
			value_changed.emit(value)

@export var min_value: float:
	set(val):
		if min_value != val:
			min_value = val    
			max_value = maxf(min_value, max_value)
			value = value # call setter to clamp value

@export var max_value: float:
	set(val):
		if max_value != val:
			max_value = maxf(val, min_value)
			value = value # call setter to clamp value

@export var step: float:
	set(val):
		if step != val:
			if min_value <= max_value:
				step = clamp(val, 0, max_value)
			else:
				step = clamp(val, min_value, 0)

var _baked_length: float:
	get: return curve.get_baked_length()

var _value_range: float:
	get: return max_value - min_value

var _range_scaling: float:
	get: return _baked_length / _value_range

var _baked_scaling: float:
	get: return _value_range / _baked_length

var pointer_offset: float:
	set(val):
		val = _get_value_with_step(val, 0, _baked_length, step * _range_scaling)
		if pointer_offset != val:
			pointer_offset = val
			value = pointer_offset * _baked_scaling + min_value


func _get_value_with_step(value: float, min_value: float, max_value: float, step: float) -> float:
	var result: float = value
	if step > 0:
		# 1. value - min_value subtracts the minimum value from the input value.
		# 2. The result is divided by step, which gives the number of steps between the minimum value and the input value.
		# 3. roundf() rounds this result to the nearest whole number.
		# 4. The result of the rounding is multiplied by step.
		# 5. Finally, the result is added to min_value to get the nearest multiple of step to value.
		result = roundf((value - min_value) / step) * step + min_value
	if min_value <= max_value:
		result = clamp(result, min_value, max_value)
	else:
		result = clamp(result, max_value, min_value)
	return result


func get_path_position() -> Vector2:
	return curve.sample_baked(pointer_offset)


func get_path_position_from_value() -> Vector2:
	return curve.sample_baked((value - min_value) * _range_scaling)
