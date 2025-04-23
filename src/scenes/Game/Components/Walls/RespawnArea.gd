##Respawns dropped cargo and spawns new ones around the platform
class_name RespawnArea extends Area2D

#toggle to determine if the cargo should get respawned or deleted
@export var respawn : bool = true
@export var random_x_radius : float = 0

##Will spawn cargo above this node
@export var targetY : Node2D 

var _cargoScene: PackedScene = preload("res://src/scenes/Game/Components/Cargo/Cargo.tscn")
var _parachuteScene :PackedScene = preload("res://src/scenes/Game/Components/Cargo/Parachute.tscn")

#the cargo that is queued to respawn
var queue : Array[CargoQueue] = []
var _timer : float = 0
const rate : float = 0.65

#spawn the cargo at a fixed rate, breaks up a ton of them falling at once
func _physics_process(delta: float) -> void:
	if _timer > rate:
		_timer -= rate
		if queue.size() > 0:
			SpawnParachuteCrates(queue.pop_front())
	_timer += delta

func SpawnParachuteCrates(queued : CargoQueue):
	var cargo : Cargo = _cargoScene.instantiate()
	var parachute : Parachute = _parachuteScene.instantiate()
	parachute.addToCargo(cargo)
	cargo.global_position = queued.pos
	cargo.setElement(queued.type)

	get_parent().add_child(cargo)


##Connected in editor to the body_entered signal of the floor
func _onFloorBodyEntered(cargo: Node2D):
	if cargo is Cargo:
		if respawn:
			var pos : Vector2 = Vector2(cargo.global_position.x + randf_range(-random_x_radius, random_x_radius), targetY.global_position.y)
			queue.append(CargoQueue.new(pos, cargo.getElement()))
		cargo.queue_free()


class CargoQueue extends RefCounted:
	var pos : Vector2
	var type : Types.Element

	func _init(_pos, _type) -> void:
		self.pos = _pos
		self.type = _type
