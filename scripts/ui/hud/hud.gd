class_name HUD extends Control

@export var _move_hud_duration: float = .5

@onready var _up_position: Vector2 = Vector2(0, -size.y)
@onready var _down_position: Vector2 = Vector2.ZERO

var _in_up: bool = true
var _need_move_hud: bool = false
var _moving: bool = false


func _ready() -> void:
	_set_position_to_up()


func _process(_delta: float) -> void:
	if _need_move_hud && !_moving:
		_moving = true
		if _in_up:
			create_tween().tween_property(self, "position", _down_position, _move_hud_duration).finished.connect(_on_moving_hud_finished)
		else:
			create_tween().tween_property(self, "position", _up_position, _move_hud_duration).finished.connect(_on_moving_hud_finished)


func _set_position_to_up() -> void:
	position = _up_position


func _on_moving_hud_finished() -> void:
	_in_up = !_in_up
	_need_move_hud = false
	_moving = false


func _on_hud_control_button_pressed() -> void:
	_need_move_hud = true
