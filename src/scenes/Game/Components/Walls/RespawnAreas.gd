##Respawns dropped cargo and spawns new ones around the platform
class_name RespawnAreas extends Node2D

##Will spawn cargo above this node
@export var platform : Node2D
##Maximum time for a box to spawn
@export var max_spawn_frequency : float = 7
##Minimum time for a box to spawn
@export var min_spawn_frequency: float = 3
##How far away from the platform can these boxes spawn
@export var random_cargo_spawn_range : float = 200

@onready var _ceiling : Area2D = get_node("Ceiling")
@onready var _timer : Timer = get_node("Timer")

var cargo_scene : PackedScene = preload("res://src/scenes/Game/Components/Cargo/Cargo.tscn")


func SpawnParachuteCrates():
	var cargo : Cargo = cargo_scene.instantiate()
	cargo.respawn = false
	cargo.global_position = Vector2(platform.global_position.x 
		+ randf_range(-random_cargo_spawn_range, random_cargo_spawn_range),
		_ceiling.global_position.y)
	get_parent().add_child(cargo)
	await get_tree().physics_frame
	#need to wait for it to update properly before making the parachute visible?... idk why this fixes it but it does
	cargo.setParachute(true)
	

func _onTimerTimeout():
	_timer.start(randf_range(min_spawn_frequency, max_spawn_frequency))
	SpawnParachuteCrates()

##Connected in editor to the body_entered signal of the floor
func _onFloorBodyEntered(cargo : Node2D):
	if cargo is Cargo and cargo.respawn:
		##Centered on the platform is likely more ideal
		#var pos : Vector2 = Vector2(body.global_position.x, _ceiling.global_position.y)
		var pos : Vector2 = Vector2(platform.global_position.x, _ceiling.global_position.y)
		cargo.queueTeleport(pos, Vector2.ZERO, 0, 0, true)
	elif cargo is Cargo and not cargo.respawn:
		cargo.destroy()
