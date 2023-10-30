class_name LabelTooltip extends Label

@export var offset: Vector2 = Vector2.ZERO

@onready var parent_control: VerticalSliderNoStick = get_parent()

var _mouse_enter: bool = false
var _is_dragging: bool = false


func _ready() -> void:
    visible = false
    parent_control.mouse_entered.connect(_on_mouse_entered)
    parent_control.mouse_exited.connect(_on_mouse_exited)
    parent_control.mouse_entered.connect(_on_mouse_entered)
    parent_control.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
    _mouse_enter = true
    visible = true


func _on_mouse_exited() -> void:
    _mouse_enter = false
    visible = _is_dragging