@tool
class_name GridBox extends Control

@export var _box: Rect2i
@export var _x_sectors: int
@export var _y_sectors: int
@export var _tick_size: float
@export var _line_color: Color = Color.WHITE
@export var _line_size: float = 1
@export var _text_color: Color = Color.WHITE

var _line_offset: float:
    get: return _line_size / 2
    set(val): pass


func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    _draw_origin()
    _draw_vertical_grid()
    _draw_horizontal_grid()
    

func _draw_origin() -> void:
    draw_line(_box.position, Vector2(_box.position.x, _box.position.y - _box.size.y), _line_color, _line_size)
    draw_line(
        Vector2(_box.position.x - _line_offset, _box.position.y),
        Vector2(_box.position.x + _box.size.x, _box.position.y), _line_color, _line_size
    )
    _draw_text_at_position("0", _box.position - Vector2i(15, -15))


func _draw_vertical_grid() -> void:
    if _x_sectors > 0:
        var x_pixel_dist: float = _box.size.x / float(_x_sectors)
        var vertical_ticks: PackedVector2Array = []

        for x in range(1, _x_sectors + 1):
            var x_sampled_val: float = (x * x_pixel_dist) + _box.position.x
            var bottom: Vector2 = Vector2(x_sampled_val - _line_offset, _box.position.y)
            
            vertical_ticks.append(bottom)
            vertical_ticks.append(bottom + Vector2(0, _tick_size))
            
            # Draw V Tick Labels
            var label_text: String = _get_label(x, false)
            _draw_text_at_position(label_text, _get_vertical_tick_label_position(bottom, label_text))
        
        # Draw V Ticks
        draw_multiline(vertical_ticks, _line_color, _line_size)


func _draw_horizontal_grid() -> void:
    if _y_sectors > 0:
        var y_pixel_dist: float = _box.size.y / float(_y_sectors)
        var horizontal_ticks: PackedVector2Array = []

        for y in range(1, _y_sectors + 1):
            var y_sampled_val: float = (y * y_pixel_dist) + _box.position.y
            var left: Vector2 = Vector2(_box.position.x, -y_sampled_val + _line_offset)
            
            horizontal_ticks.append(left)
            horizontal_ticks.append(left - Vector2(_tick_size, 0))
            
            # Draw H Tick Labels
            var label_text: String = _get_label(y, false)
            _draw_text_at_position(label_text, _get_horizontal_tick_label_position(left, label_text))
        
        # Draw H Ticks
        draw_multiline(horizontal_ticks, _line_color, _line_size)
        

func _draw_text_at_position(text: String, position: Vector2) -> void:
    draw_string(
            get_theme_default_font(), 
            position,
            text,
            HORIZONTAL_ALIGNMENT_CENTER,
            -1,
            get_theme_default_font_size(),
            _text_color,
            TextServer.JUSTIFICATION_NONE, TextServer.DIRECTION_AUTO, TextServer.ORIENTATION_HORIZONTAL
        )


func _get_vertical_tick_label_position(base_position: Vector2, text: String) -> Vector2:
    # magic numbers in here just to make it look nice
    return base_position + Vector2(
        -get_theme_default_font().get_string_size(text).x / 4,
        get_theme_default_font_size() + _tick_size
    )

func _get_horizontal_tick_label_position(base_position: Vector2, text: String) -> Vector2:
    # magic numbers in here just to make it look nice
    return base_position - Vector2(
        get_theme_default_font().get_string_size(text).x / 1.8 + _tick_size,
        - get_theme_default_font_size() * 0.35
    )

func _get_label(line_value: float, is_decimal: bool) -> String:
    return ("%.1f" if is_decimal else "%s") % snapped(line_value, 0.1) 