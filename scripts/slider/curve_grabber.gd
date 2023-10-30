class_name CurveGrabber extends Control

signal drag_started
signal drag_ended(value: float)

@export var path: Path2DRange
@onready var curve: Curve2D = path.curve


var _is_dragging: bool = false
var _dragging_start_position: Vector2 = Vector2.ZERO
# var _drag_delta: Vector2 = Vector2.ZERO
var _mouse_inside: bool:
	get: return get_global_rect().has_point(get_global_mouse_position())
	set(val): pass


func _ready() -> void:
	path.path_value = curve.get_closest_offset(position)
	position = _get_path_position()


func _process(delta: float) -> void:
	if _is_dragging:
		position = get_global_mouse_position() - _dragging_start_position
		path.path_value = curve.get_closest_offset(position)
		position = _get_path_position()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if _mouse_inside:
				_is_dragging = true
				_dragging_start_position = get_global_mouse_position() - position
				drag_started.emit()
		else:
			_is_dragging = false
			_dragging_start_position = Vector2.ZERO
	# elif event is InputEventMouseMotion && _is_dragging:
	# 	_drag_delta = get_global_mouse_position() - position - _dragging_start_position
	# 	print(_drag_delta)
	# else:
	# 	_drag_delta = Vector2.ZERO


func _get_path_position() -> Vector2:
	return path.get_path_position() - pivot_offset