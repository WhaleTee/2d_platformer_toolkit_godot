class_name JumpingTab extends HUDInputEventConnector

@export var air_acceleration_slider: HSlider

var player_movement: PlayerMovement:
	get: return player_movement
	set(val):
		player_movement = val
var player_jump: PlayerJump:
	get: return player_jump
	set(val):
		player_jump = val


func connect_input_events() -> void:
	pass
