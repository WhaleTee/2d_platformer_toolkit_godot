class_name Path2DRange extends Path2D

signal value_changed(value: float)

var value: float = 0:
    get: return value
    set(val):
        val = _get_value_with_step(val, min_value, max_value, step)
        if value != val:
            value = val
            value_changed.emit(value)

var min_value: float = 0:
    get: return min_value
    set(val):
        if min_value != val:
            min_value = val    
            max_value = maxf(min_value, max_value)
            value = value # call setter to clamp value

var max_value: float = 100:
    get: return max_value
    set(val):
        if max_value != val:
            max_value = maxf(val, min_value)
            value = value # call setter to clamp value

var step: float = 1:
    get: return step
    set(val):
        if step != val:
            if min_value <= max_value:
                step = clamp(val, min_value, max_value)
            else:
                step = clamp(val, max_value, min_value)


var _value_multiplier: float:
    get: return (max_value - min_value) / curve.get_baked_length()
    set(val): pass

var _path_multiplier: float:
    get: return curve.get_baked_length() / (max_value - min_value)
    set(val): pass

var path_value: float:
    get: return path_value
    set(val):
        val = _get_value_with_step(val, 0, curve.get_baked_length(), step * _path_multiplier)
        if path_value != val:
            path_value = val
            value = (path_value + min_value) * _value_multiplier


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
    return curve.sample_baked(path_value)