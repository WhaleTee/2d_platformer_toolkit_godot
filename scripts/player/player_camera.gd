class_name PlayerCamera extends Camera2D

signal need_smoothing(value: bool)

@export var player: CharacterBody2D
@export var settings_preset: PlayerCameraPreset:
	get: return settings_preset
	set(val):
		settings_preset = val
		if settings_preset:
			_apply_preset()

@onready var _init_zoom: Vector2 = zoom

var _damping_x: float = 0
var _damping_y: float = 0
var _lookahead: float = 0
var _fixed_lookahead: bool = false
var _camera_locked: bool = false
var _ignore_jumps: bool = false
var _panic_zone_enabled: bool = false
var _panic_zone: Rect2i
var _panic_speed: float


func _ready() -> void:
	if settings_preset:
		_apply_preset()


func _physics_process(_delta: float) -> void:
	_process_following_player(_delta)
	_process_signals(_delta)


func _process_following_player(_delta: float) -> void:
	if player:
		_follow_x(_delta)
		_follow_y(_delta)
		_follow_y_ignore_jumps(_delta)
		_follow_player_panic_zone(_delta)


func _follow_x(_delta: float, _speed: float = 1.0) -> void:
	if !_camera_locked:
		var desire_offset_x: float = player.global_position.x - global_position.x
		if _lookahead > 0:
			desire_offset_x += player.velocity.x * _lookahead
		if _damping_x > 0:
			desire_offset_x /= _damping_x / _delta
		global_position.x += desire_offset_x * _speed


func _follow_y(_delta: float, _speed: float = 1.0) -> void:
	if !_camera_locked && !_ignore_jumps:
		var desire_offset_y: float = player.global_position.y - global_position.y
		if _damping_y > 0:
			desire_offset_y /= _damping_y / _delta
		global_position.y += desire_offset_y * _speed


func _follow_y_ignore_jumps(_delta: float) -> void:
	if !_camera_locked && _ignore_jumps && player.is_on_floor():
		var desire_offset_y: float = player.global_position.y - global_position.y
		if _damping_y > 0:
			desire_offset_y /= _damping_y / _delta
		global_position.y += desire_offset_y


func _follow_player_panic_zone(_delta) -> void:
	if player && !_camera_locked && _panic_zone_enabled:
		var upBound: float = global_position.y - _panic_zone.size.y / 2.0
		var downBound: float = global_position.y + _panic_zone.size.y / 2.0
		if player.global_position.y < upBound || player.global_position.y > downBound:
			_follow_y(_delta, _panic_speed)


func _process_signals(_delta: float) -> void:
	need_smoothing.emit(player && player.velocity == Vector2.ZERO)


func _apply_preset() -> void:
	_damping_x = settings_preset.damping_x
	_damping_y = settings_preset.damping_y
	_lookahead = settings_preset.lookahead
	_ignore_jumps = settings_preset.ignore_jumps
	_panic_zone_enabled = settings_preset.panic_zone_enable
	_panic_zone = settings_preset.panic_zone
	_panic_speed = settings_preset.panic_speed
	

func _on_camera_zoom_slider_value_changed(_value: float) -> void:
	zoom = Vector2.ONE * _value * _init_zoom


func _on_camera_lock_button_pressed() -> void:
	_camera_locked = !_camera_locked


func _on_camera_damping_x_slider_value_changed(_value: float) -> void:
	_damping_x = _value


func _on_camera_damping_y_slider_value_changed(_value: float) -> void:
	_damping_y = _value


func _on_camera_lookahead_slider_value_changed(_value: float) -> void:
	_lookahead = _value


func _on_camera_fixed_lookahead_button_pressed() -> void:
	_fixed_lookahead = !_fixed_lookahead


func _on_camera_ignore_jumps_button_pressed() -> void:
	_ignore_jumps = !_ignore_jumps

	
func _on_preset_select_button_pressed(_preset: PlayerCameraPreset) -> void:
	settings_preset = _preset
	_apply_preset()


func _on_camera_panic_zone_button_pressed(_value: bool) -> void:
	_panic_zone_enabled = _value


func _on_camera_panic_zone_changed(_rect: Rect2i) -> void:
	_panic_zone = _rect
