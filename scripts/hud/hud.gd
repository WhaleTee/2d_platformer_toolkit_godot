class_name HUD extends HUDInputEventConnector

@export var move_hud_duration: float = .5
@export var up_position:= Vector2(0, -size.y)
@export var down_position:= Vector2(0, 0)
@export var hud_control_button: Button


# Tabs Settings
@export var player_movement: PlayerMovement
@export var player_jump: PlayerJump
@export var player_camera: PlayerCamera
@export var jumping_tab: JumpingTab

@onready var running_tab: RunningTab = $TabContainer/Running
@onready var camera_tab: CameraTab = $TabContainer/Camera


var in_up: bool = true
var need_move_hud: bool = false


func _ready() -> void:
	_set_position_to_up()
	connect_input_events()


func _process(_delta: float) -> void:
	if need_move_hud:
		if in_up:
			create_tween().tween_property(self, "position", down_position, move_hud_duration).finished.connect(_on_moving_hud_finished)
		else:
			create_tween().tween_property(self, "position", up_position, move_hud_duration).finished.connect(_on_moving_hud_finished)


func _set_position_to_up() -> void:
	position = up_position


func connect_input_events() -> void:
	hud_control_button.pressed.connect(_on_hud_control_button_pressed)

	#Running Tab

	#Jumping Tab
	jumping_tab.player_jump = player_jump
	jumping_tab.connect_input_events()
	#Cameta Tab
	camera_tab.camera = player_camera
	camera_tab.connect_input_events()


func _on_moving_hud_finished() -> void:
	in_up = !in_up
	need_move_hud = false


func _on_hud_control_button_pressed() -> void:
	need_move_hud = true
