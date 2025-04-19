extends CutsceneBehaviour

@export var cargoScene: PackedScene

var spawnedCargo: Node

func Activate() -> void:
	PhysicsServer2D.set_active(true)
	var cargo : ParachutedCargo = cargoScene.instantiate()
	cargo.process_mode = Node.PROCESS_MODE_ALWAYS
	spawnedCargo = cargo
	add_child(cargo) ## NOTE Cargo is being added as a child of this scene, which is not ideal.
	cargo.global_position = global_position
	cargo.setParachute(true)

func Finish() -> void:
	spawnedCargo.queue_free()
	PhysicsServer2D.set_active(false)
