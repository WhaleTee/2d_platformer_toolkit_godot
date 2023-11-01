class_name JumpHeightCurve extends Control

@export var _curve_color: Color = Color.GREEN
@export var _line_size: float = 1
@export var player_jump: PlayerJump

@onready var physics_ticks_per_second: float = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

var jump_curve_points: PackedVector2Array = []


func _ready() -> void:
	if player_jump:
		player_jump.settings_preset.value_changed.connect(_on_jump_preset_value_changed)


func _draw() -> void:
	if player_jump:
		var h: float = player_jump.jump_height
		var t_h: float = player_jump.time_to_apex * h
		var p0: Vector2 = Vector2.ZERO
		var p1: Vector2 = Vector2(t_h, -h)
		var p2: Vector2 = Vector2(t_h * 2, 0)

		jump_curve_points.clear()

		for i in range(physics_ticks_per_second + 1):
			var point = _quadratic_bezier(p0, p1, p2, i / physics_ticks_per_second)
			jump_curve_points.append(point)

		draw_polyline(jump_curve_points, _curve_color, _line_size, true)


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	return q0.lerp(q1, t)


func _on_jump_preset_value_changed(setting: String) -> void:
	queue_redraw()