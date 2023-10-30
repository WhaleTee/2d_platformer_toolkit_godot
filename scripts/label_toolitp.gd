class_name LabelTooltip extends Label

@export var _grabber: CurveGrabber


func _process(delta: float) -> void:
	visible = _grabber.mouse_inside || _grabber.is_dragging