class_name GameMainViewport extends SubViewportContainer

signal game_main_viewport_material_init(shader: ShaderMaterial)


func _ready():
	game_main_viewport_material_init.emit(material)
