class_name SliderLabel extends Label

@export var offset: Vector2
@export var grabber_shift: Vector2

@onready var _slider: Slider = get_parent();
@onready var _slider_value_step_px = _slider.max_value / _slider.size.y

var _slider_lower_global_position: Vector2:
	get: return Vector2(_slider.global_position.x, _slider.global_position.y + _slider.size.y)
	set(_val):
		pass
var _shift: Vector2:
	get: return Vector2(grabber_shift.x * _slider.value / _slider.max_value, grabber_shift.y * _slider.value / _slider.max_value)
	set(_val):
		pass

var _mouse_enter: bool = false
var _is_dragging: bool = false


func _ready() -> void:
	visible = false
	_slider.drag_started.connect(_on_drag_started)
	_slider.drag_ended.connect(_on_drag_ended)
	_slider.mouse_entered.connect(_on_mouse_entered)
	_slider.mouse_exited.connect(_on_mouse_exited)


func _process(_delta: float) -> void:
	if visible:
		global_position = Vector2(_slider_lower_global_position.x, round(_slider_lower_global_position.y - _slider.value * _slider_value_step_px))
		global_position += _shift
		global_position += offset


func _on_drag_started() -> void:
	_is_dragging = true
	visible = true


func _on_drag_ended(_value_changed: bool) -> void:
	_is_dragging = false
	visible = _mouse_enter


func _on_mouse_entered() -> void:
	_mouse_enter = true
	visible = true


func _on_mouse_exited() -> void:
	_mouse_enter = false
	visible = _is_dragging
