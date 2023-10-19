class_name CameraSmoothMoving extends Node2D

@onready var camera: Camera2D = get_parent()

var _game_main_viewport_shader: ShaderMaterial
var need_smoothing: bool = false


func _process(_delta: float):
    _process_shooth_transition(_delta)


func _process_shooth_transition(_delta: float) -> void:
    if need_smoothing && _game_main_viewport_shader:
        var camera_global_position: Vector2 = camera.global_position
        _game_main_viewport_shader.set_shader_parameter("camera_offset", camera_global_position.round() - camera_global_position)
        camera.global_position = camera_global_position.round()


func _on_main_viewport_shader_init(shader: ShaderMaterial) -> void:
    _game_main_viewport_shader = shader


func _on_need_smoothing(value: bool) -> void:
    need_smoothing = value