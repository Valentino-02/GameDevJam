class_name CameraController extends Camera2D

@export var cargo_scene : PackedScene
@export var player: Player

@export var camera_smoothing_speed : float = 3

var pause_follow: bool = false

func _ready() -> void:
	SignalBus.game_over.connect(func(): pause_follow = true)
	SignalBus.restart.connect(func(): pause_follow = false)

func _process(delta):
	drop_cargo_if_input()
	if !pause_follow:
		center_camera(delta)


func center_camera(delta : float):
	var midpoint : Vector2 = (
							 player.left_character.global_position + 
							 player.right_character.global_position + 
							 player.right_rope.platform.global_position
							 ) / 3.0
	self.global_position = self.global_position.lerp(midpoint, camera_smoothing_speed * delta )

func drop_cargo_if_input() -> bool:
	if Input.is_action_just_pressed("RightClick"):
		var cargo : Node2D = cargo_scene.instantiate()
		get_parent().add_child(cargo)
		cargo.global_position = get_global_mouse_position()
		return true
	return false