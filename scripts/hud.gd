class_name HUD extends Control

# Camera Input Events
signal camera_lock_button_pressed()
signal camera_zoom_slider_value_changed(value: float)
signal camera_damping_x_slider_value_changed(value: float)
signal camera_damping_y_slider_value_changed(value: float)
signal camera_lookahead_slider_value_changed(value: float)
signal camera_ignore_jumps_button_pressed()
signal camera_enable_panic_zone_button_pressed()

@export var move_hud_duration: float = .5
@export var up_position:= Vector2(0, -size.y)
@export var down_position:= Vector2(0, 0)

# Camera Settings
@export var camera: PlayerCamera
@onready var camera_lock_button: CheckBox = $TabContainer/Camera/CameraLockButton
@onready var camera_zoom_slider: HSlider = $TabContainer/Camera/CameraZoomSlider
@onready var camera_damping_x_slider: HSlider = $TabContainer/Camera/CameraDampingXSlider
@onready var camera_damping_y_slider: HSlider = $TabContainer/Camera/CameraDampingYSlider
@onready var camera_lookahead_slider: HSlider = $TabContainer/Camera/CameraLookaheadSlider
@onready var camera_ignore_jumps_button: CheckBox = $TabContainer/Camera/CameraIgnoreJumpsButton

var in_up: bool = true
var need_move_hud: bool = false


func _ready() -> void:
	_set_position_to_up()
	_register_input_events()


func _process(_delta: float) -> void:
	if need_move_hud:
		if in_up:
			create_tween().tween_property(self, "position", down_position, move_hud_duration).finished.connect(_on_moving_hud_finished)
		else:
			create_tween().tween_property(self, "position", up_position, move_hud_duration).finished.connect(_on_moving_hud_finished)


func _set_position_to_up() -> void:
	position = up_position


func _register_input_events() -> void:
	if camera:
		camera_lock_button.pressed.connect(camera._on_camera_lock_button_pressed)
		camera_zoom_slider.value_changed.connect(camera._on_camera_zoom_slider_value_changed)
		camera_damping_x_slider.value_changed.connect(camera._on_camera_damping_x_slider_value_changed)
		camera_damping_y_slider.value_changed.connect(camera._on_camera_damping_y_slider_value_changed)
		camera_lookahead_slider.value_changed.connect(camera._on_camera_lookahead_slider_value_changed)
		camera_ignore_jumps_button.pressed.connect(camera._on_camera_ignore_jumps_button_pressed)
		# camera_enable_panic_zone_button.pressed.connect(camera._on_camera_enable_panic_zone_button_pressed)


func _on_moving_hud_finished() -> void:
	in_up = !in_up
	need_move_hud = false


func _on_hud_control_button_pressed() -> void:
	need_move_hud = true
