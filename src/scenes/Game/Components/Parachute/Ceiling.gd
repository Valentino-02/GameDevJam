class_name Ceiling extends Area2D

@onready var platform : RigidBody2D = get_node("../PlayerCharacter/Platform")
var cargo_scene : PackedScene = preload("res://src/scenes/Game/Components/Cargo/Cargo.tscn")

##Connected in editor to the body_entered signal of the floor
func _onFloorBodyEntered(cargo : Node2D):
	if cargo is Cargo and cargo.respawn:
		##Centered on the platform is likely more ideal
		#var pos : Vector2 = Vector2(body.global_position.x, self.global_position.y)
		var pos : Vector2 = Vector2(platform.global_position.x, self.global_position.y)
		cargo.queueTeleport(pos, Vector2.ZERO, 0, 0, true)



func _ready():
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.timeout.connect( func ():
		timer.start(randf_range(min_spawn_frequency, max_spawn_frequency ))
		SpawnParachuteCrates())
	timer.start((min_spawn_frequency + max_spawn_frequency)/ 2)

##Maximum time for a box to spawn
@export var max_spawn_frequency : float = 7
##Minimum time for a box to spawn
@export var min_spawn_frequency: float = 3
##How far away from the platform can these boxes spawn
@export var random_cargo_spawn_range : float = 200

func SpawnParachuteCrates():
	var cargo : Cargo = cargo_scene.instantiate()
	cargo.respawn = false
	cargo.global_position = Vector2(platform.global_position.x 
		+ randf_range(-random_cargo_spawn_range, random_cargo_spawn_range),
		self.global_position.y)
	add_child(cargo)
	cargo.setParachute(true)
