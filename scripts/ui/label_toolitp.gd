class_name LabelTooltip extends Label

@onready var _grabber: CurveGrabber = get_parent()


func _process(delta: float) -> void:
	visible = _grabber.mouse_inside || _grabber.is_dragging