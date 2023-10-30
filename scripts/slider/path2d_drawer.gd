class_name Path2DDrawer extends Control

@export var path: Path2D
@export var line_size: int = 1
@export var color: Color = Color.YELLOW_GREEN


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var vertices: = PackedVector2Array()
	for i in range(path.curve.get_baked_length()):
		var point = path.curve.sample_baked(i)
		vertices.append(point)
	draw_polyline(vertices, color, line_size)
