class_name PlayerCamera extends Camera2D

@export var player: CharacterBody2D
@export var camera_preset: PlayerCameraPreset

@onready var _init_zoom: Vector2 = zoom


func _physics_process(delta: float) -> void:
	_follow_player(delta)


func _follow_player(delta: float) -> void:
	if player:
		_follow_x(delta)
		_follow_y(delta)
		_follow_y_ignore_jumps(delta)
		_follow_player_panic_zone(delta)
		_apply_offset()


func _follow_x(delta: float, speed: float = 1.0) -> void:
	if !camera_preset.locked:
		var desire_offset_x: float = player.global_position.x - global_position.x
		if camera_preset.lookahead > 0:
			desire_offset_x += player.velocity.x * camera_preset.lookahead
		if camera_preset.damping_x > 0:
			desire_offset_x /= camera_preset.damping_x / delta
		global_position.x += desire_offset_x * speed


func _follow_y(delta: float, speed: float = 1.0) -> void:
	if !camera_preset.locked && !camera_preset.ignore_jumps:
		var desire_offset_y: float = player.global_position.y - global_position.y
		if camera_preset.damping_y > 0:
			desire_offset_y /= camera_preset.damping_y / delta
		global_position.y += desire_offset_y * speed


func _follow_y_ignore_jumps(delta: float) -> void:
	if !camera_preset.locked && camera_preset.ignore_jumps && player.is_on_floor():
		var desire_offset_y: float = player.global_position.y - global_position.y
		if camera_preset.damping_y > 0:
			desire_offset_y /= camera_preset.damping_y / delta
		global_position.y += desire_offset_y


func _follow_player_panic_zone(delta) -> void:
	if player && !camera_preset.locked && camera_preset.panic_zone_enable:
		var upBound: float = global_position.y - camera_preset.panic_zone.size.y / 2.0
		var downBound: float = global_position.y + camera_preset.panic_zone.size.y / 2.0
		if player.global_position.y < upBound || player.global_position.y > downBound:
			_follow_y(delta, camera_preset.panic_speed)


func _apply_offset() -> void:
	global_position += camera_preset.offset


func _on_zoom_value_changed(value: float) -> void:
	zoom = Vector2.ONE * value * _init_zoom


func _on_lock_camera_pressed() -> void:
	camera_preset.locked = !camera_preset.locked


func _on_damping_x_value_changed(value: float) -> void:
	camera_preset.damping_x = value


func _on_damping_y_value_changed(value: float) -> void:
	camera_preset.damping_y = value


func _on_lookahead_value_changed(value: float) -> void:
	camera_preset.lookahead = value


func _on_ignore_jumps_pressed() -> void:
	camera_preset.ignore_jumps = !camera_preset.ignore_jumps


func _on_enable_panic_zone_pressed() -> void:
	camera_preset.panic_zone_enable = !camera_preset.panic_zone_enable


func _on_panic_zone_changed(rect: Rect2i) -> void:
	camera_preset.panic_zone = rect
