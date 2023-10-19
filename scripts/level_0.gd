class_name Repeator extends Node2D

signal game_main_viewport_material_init(shader: ShaderMaterial)


func on_game_main_viewport_material_init(shader: ShaderMaterial):
	game_main_viewport_material_init.emit(shader)
