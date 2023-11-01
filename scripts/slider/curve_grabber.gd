class_name CurveGrabber extends Control

signal drag_started
signal drag_ended(value: float)

@export var path: Path2DRange
@onready var _curve: Curve2D = path.curve


var mouse_inside: bool:
	get: return get_global_rect().has_point(get_global_mouse_position())
	set(val): pass

var is_dragging: bool = false

var _dragging_start_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	path.path_value = _curve.get_closest_offset(position)
	position = path.get_path_position() - pivot_offset


func _process(delta: float) -> void:
	if is_dragging:
		position = get_global_mouse_position() - _dragging_start_position + pivot_offset
		path.path_value = _curve.get_closest_offset(position)
		position = path.get_path_position() - pivot_offset


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
