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


func _physics_process(delta: float) -> void:
	_process_following_player(delta)
	_process_signals(delta)


func _process_following_player(delta: float) -> void:
	if player:
		_follow_x(delta)
		_follow_y(delta)
		_follow_y_ignore_jumps(delta)
		_follow_player_panic_zone(delta)


func _follow_x(delta: float, speed: float = 1.0) -> void:
	if !_camera_locked:
		var desire_offset_x: float = player.global_position.x - global_position.x
		if _lookahead > 0:
			desire_offset_x += player.velocity.x * _lookahead
		if _damping_x > 0:
			desire_offset_x /= _damping_x / delta
		global_position.x += desire_offset_x * speed


func _follow_y(delta: float, speed: float = 1.0) -> void:
	if !_camera_locked && !_ignore_jumps:
		var desire_offset_y: float = player.global_position.y - global_position.y
		if _damping_y > 0:
			desire_offset_y /= _damping_y / delta
		global_position.y += desire_offset_y * speed


func _follow_y_ignore_jumps(delta: float) -> void:
	if !_camera_locked && _ignore_jumps && player.is_on_floor():
		var desire_offset_y: float = player.global_position.y - global_position.y
		if _damping_y > 0:
			desire_offset_y /= _damping_y / delta
		global_position.y += desire_offset_y


func _follow_player_panic_zone(delta) -> void:
	if player && !_camera_locked && _panic_zone_enabled:
		var upBound: float = global_position.y - _panic_zone.size.y / 2.0
		var downBound: float = global_position.y + _panic_zone.size.y / 2.0
		if player.global_position.y < upBound || player.global_position.y > downBound:
			_follow_y(delta, _panic_speed)


func _process_signals(delta: float) -> void:
	need_smoothing.emit(player && player.velocity == Vector2.ZERO)


func _apply_preset() -> void:
	_damping_x = settings_preset.damping_x
	_damping_y = settings_preset.damping_y
	_lookahead = settings_preset.lookahead
	_ignore_jumps = settings_preset.ignore_jumps
	_panic_zone_enabled = settings_preset.panic_zone_enable
	_panic_zone = settings_preset.panic_zone
	_panic_speed = settings_preset.panic_speed
	

func _on_zoom_value_changed(value: float) -> void:
	zoom = Vector2.ONE * value * _init_zoom


func _on_lock_camera_pressed() -> void:
	_camera_locked = !_camera_locked


func _on_damping_x_value_changed(value: float) -> void:
	_damping_x = value


func _on_damping_y_value_changed(value: float) -> void:
	_damping_y = value


func _on_lookahead_value_changed(value: float) -> void:
	_lookahead = value


func _on_enable_fixed_lookahead_pressed() -> void:
	_fixed_lookahead = !_fixed_lookahead


func _on_ignore_jumps_pressed() -> void:
	_ignore_jumps = !_ignore_jumps


func _on_enable_panic_zone_pressed() -> void:
	_panic_zone_enabled = !_panic_zone_enabled


func _on_panic_zone_changed(rect: Rect2i) -> void:
	_panic_zone = rect

	
func _on_preset_select_pressed(preset: PlayerCameraPreset) -> void:
	settings_preset = preset
	_apply_preset()