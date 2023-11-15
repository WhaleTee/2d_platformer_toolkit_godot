@tool
class_name CurveGrabber extends Control

signal drag_started
signal drag_ended(value: float)

@export var path: Path2DRange:
	set(val):
		if val && val != path:
			path = val
			_update_position_from_value(path.value)
			path.value_changed.connect(_update_position_from_value)

var is_dragging: bool = false
var _dragging_start_position: Vector2 = Vector2.ZERO

var mouse_inside: bool:
	get: return get_global_rect().has_point(get_global_mouse_position())


func _process(delta: float) -> void:
	if is_dragging:
		position = get_global_mouse_position() - _dragging_start_position + pivot_offset
		path.pointer_offset = path.curve.get_closest_offset(position)
		position = path.get_path_position() - pivot_offset
	else:
		_update_position_from_value(path.value)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if mouse_inside:
				is_dragging = true
				_dragging_start_position = get_global_mouse_position() - position
				drag_started.emit()
		else:
			is_dragging = false
			_dragging_start_position = Vector2.ZERO
			drag_ended.emit(path.value)


func _update_position_from_value(value: float) -> void:
	position = path.get_path_position_from_value() - pivot_offset
