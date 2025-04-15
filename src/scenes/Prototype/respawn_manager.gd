class_name RespawnManager extends Marker2D

@export var player_scene: PackedScene
@export var cam_controller: CameraController

func _ready() -> void:
	SignalBus.restart.connect(restart)

func restart() -> void:
	var inst = player_scene.instantiate()
	get_parent().add_child(inst)
	inst.global_position = global_position
	
	##TODO: Fix camera position on respawn
	cam_controller.player = inst.get_script()
	