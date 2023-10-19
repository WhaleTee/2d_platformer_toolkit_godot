@tool
class_name PlayerCameraDebug extends Node2D

const DEBUG_DRAW_LINE: int = 1 # px

@export var debug: bool

@onready var settings_preset: PlayerCameraPreset = get_parent().settings_preset

var panic_zone_position: Vector2:
    get: return settings_preset.panic_zone.position
    set(_val):
        pass
var panic_zone_size: Vector2:
    get: return settings_preset.panic_zone.size
    set(_val):
        pass


func _process(_delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    if Engine.is_editor_hint() && debug:
        draw_set_transform(global_position)
        if settings_preset && settings_preset.panic_zone_enble:
            draw_rect(
                Rect2(
                    global_position.x + panic_zone_position.x - panic_zone_size.x / 2.0,
                    global_position.y + panic_zone_position.y - panic_zone_size.y / 2.0,
                    settings_preset.panic_zone.size.x,
                    settings_preset.panic_zone.size.y
                ),
                Color.RED,
                false,
                DEBUG_DRAW_LINE
            )