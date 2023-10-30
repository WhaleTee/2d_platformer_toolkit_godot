class_name CameraTab extends HUDInputEventConnector

@export var _camera_lock_button: CheckBox
@export var _camera_zoom_slider: HSlider
@export var _camera_damping_x_slider: HSlider
@export var _camera_damping_y_slider: HSlider
@export var _camera_lookahead_slider: HSlider
@export var _camera_fixed_lookahed_button: CheckBox
@export var _camera_ignore_jumps_button: CheckBox
@export var _camera_panic_zone_button: CheckBox

var camera: PlayerCamera:
    get: return camera
    set(val):
        camera = val


func connect_input_events() -> void:
    if camera:
        _camera_lock_button.pressed.connect(camera._on_camera_lock_button_pressed)
        _camera_zoom_slider.value_changed.connect(camera._on_camera_zoom_slider_value_changed)
        _camera_damping_x_slider.value_changed.connect(camera._on_camera_damping_x_slider_value_changed)
        _camera_damping_y_slider.value_changed.connect(camera._on_camera_damping_y_slider_value_changed)
        _camera_lookahead_slider.value_changed.connect(camera._on_camera_lookahead_slider_value_changed)
        _camera_fixed_lookahed_button.pressed.connect(camera._on_camera_fixed_lookahead_button_pressed)
        _camera_ignore_jumps_button.pressed.connect(camera._on_camera_ignore_jumps_button_pressed)
        _camera_panic_zone_button.pressed.connect(camera._on_camera_panic_zone_button_pressed)