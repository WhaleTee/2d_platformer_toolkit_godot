class_name JumpHeightChart extends Control

@export var _player_movement: PlayerMovement
@export var _grid_box: GridBox
@export var _curve_color: Color = Color.GREEN
@export var _curve_size: float = 1
@export var _dot_color: Color = Color.BLACK
@export var _dot_size: float = 2

@onready var _physics_ticks_per_second: float = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

var _player_movement_settings: PlayerJumpPreset:
	get: return _player_movement.jump_preset if _player_movement else null
var _jump_curve_points: PackedVector2Array = []
var _jump_height_position: float:
	get: return _player_movement_settings.jump_height
var _jump_time_position: float:
	get: return _grid_box.box.size.x / _grid_box.x_max * _player_movement_settings.time_to_apex
var _fall_time_position: float:
	get: return _grid_box.box.size.x / _grid_box.x_max * _player_movement_settings.time_to_floor


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	# draw grid box
	if _grid_box:
		_draw_origin(_grid_box)
		_draw_vertical_grid(_grid_box)
		_draw_horizontal_grid(_grid_box)
	
	# draw curve
	if _grid_box && _player_movement_settings:
		_draw_curve()


func _draw_curve() -> void:
	_jump_curve_points.clear()
	_fill_time_to_apex_curve()
	_fill_time_to_floor_curve()
	# draw curve
	draw_polyline(_jump_curve_points, _curve_color, _curve_size, true)

	# draw dots
	draw_circle(_jump_curve_points[0], _dot_size, _dot_color)
	# this dot hides transition between apex and floor curves at high point
	draw_circle(_jump_curve_points[_physics_ticks_per_second / 2], _dot_size, _dot_color)


func _fill_time_to_apex_curve() -> void:
	var h: float = _jump_height_position
	var jump_time: float = _jump_time_position
	var p0: Vector2 = Vector2(_grid_box.line_offset, 0)
	var p1: Vector2 = Vector2(jump_time - _grid_box.line_offset, -2 * h)
	var p2: Vector2 = Vector2(2 * jump_time - _grid_box.line_offset, 0)

	for i in _physics_ticks_per_second / 2 + 1:
		var point = _quadratic_bezier(p0, p1, p2, i / _physics_ticks_per_second)
		_jump_curve_points.append(point)
	

func _fill_time_to_floor_curve() -> void:
	var h: float = _jump_height_position
	var jump_time: float = _jump_time_position
	var fall_time: float = _fall_time_position
	var p0: Vector2 = Vector2(jump_time - fall_time - _grid_box.line_offset, 0)
	var p1: Vector2 = Vector2(jump_time - _grid_box.line_offset, -2 * h)
	var p2: Vector2 = Vector2(jump_time + fall_time - _grid_box.line_offset, 0)

	for i in range(_physics_ticks_per_second / 2 + 1, _physics_ticks_per_second + 1):
		var point = _quadratic_bezier(p0, p1, p2, i / _physics_ticks_per_second)
		_jump_curve_points.append(point)


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	return q0.lerp(q1, t)


func _draw_origin(grid_box: GridBox) -> void:
	draw_line(
		grid_box.box.position,
		Vector2(grid_box.box.position.x, grid_box.box.position.y - grid_box.box.size.y), grid_box.line_color, grid_box.line_size
	)
	draw_line(
		Vector2(grid_box.box.position.x - grid_box.line_offset, grid_box.box.position.y),
		Vector2(grid_box.box.position.x + grid_box.box.size.x, grid_box.box.position.y), grid_box.line_color, grid_box.line_size
	)
	_draw_text_at_position("0",  grid_box.text_color, grid_box.box.position - Vector2i(15, -15))


func _draw_vertical_grid(grid_box: GridBox) -> void:
	var x_max: float = grid_box.x_max
	if x_max > 0:
		var scaling: float = grid_box.box.size.x / float(x_max)
		var vertical_ticks: PackedVector2Array = []
		var step: float = grid_box.x_step
		var x = step
		while x <= x_max:
			var x_sampled_val: float = (x * scaling) + grid_box.box.position.x
			var bottom: Vector2 = Vector2(x_sampled_val - grid_box.line_offset, grid_box.box.position.y)
			
			vertical_ticks.append(bottom)
			vertical_ticks.append(bottom + Vector2(0, grid_box.tick_size))
			
			var label_text: String = _get_label(x, _is_decimal(step))
			_draw_text_at_position(
				label_text,
				grid_box.text_color,
				_get_vertical_tick_label_position(bottom, label_text, grid_box.tick_size)
			)
			x += step
		
		draw_multiline(vertical_ticks, grid_box.line_color, grid_box.line_size)


func _draw_horizontal_grid(grid_box: GridBox) -> void:
	var y_max: float = grid_box.y_max
	if y_max > 0:
		var scaling: float = grid_box.box.size.y / float(y_max)
		var horizontal_ticks: PackedVector2Array = []
		var step: float = grid_box.y_step
		var y = step
		while y <= y_max:
			var y_sampled_val: float = (y * scaling) + grid_box.box.position.y
			var left: Vector2 = Vector2(grid_box.box.position.x, -y_sampled_val + grid_box.line_offset)
			
			horizontal_ticks.append(left)
			horizontal_ticks.append(left - Vector2(grid_box.tick_size, 0))
			
			var label_text: String = _get_label(y, _is_decimal(step))
			_draw_text_at_position(
				label_text,
				grid_box.text_color,
				_get_horizontal_tick_label_position(left, label_text, grid_box.tick_size)
			)
			y += step
		
		draw_multiline(horizontal_ticks, grid_box.line_color, grid_box.line_size)
		

func _draw_text_at_position(text: String, text_color: Color, position: Vector2) -> void:
	draw_string(
			get_theme_default_font(), 
			position,
			text,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			get_theme_default_font_size(),
			text_color,
			TextServer.JUSTIFICATION_NONE, TextServer.DIRECTION_AUTO, TextServer.ORIENTATION_HORIZONTAL
		)


func _get_vertical_tick_label_position(base_position: Vector2, text: String, tick_size: float) -> Vector2:
	# magic numbers here just to make it look nice
	return base_position + Vector2(
		-get_theme_default_font().get_string_size(text).x / 4,
		get_theme_default_font_size() + tick_size
	)


func _get_horizontal_tick_label_position(base_position: Vector2, text: String, tick_size: float) -> Vector2:
	# magic numbers here just to make it look nice
	return base_position - Vector2(
		get_theme_default_font().get_string_size(text).x / 1.8 + tick_size,
		-get_theme_default_font_size() * 0.35
	)


func _get_label(value: float, is_decimal: bool) -> String:
	return ("%.2f" if !is_decimal else "%s") % snapped(value, 0.01)


func _is_decimal(value: float) -> bool:
	return is_equal_approx(value, int(value))
