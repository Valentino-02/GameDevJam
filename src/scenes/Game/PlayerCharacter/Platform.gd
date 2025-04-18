extends RigidBody2D

@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5

@onready var collider: CollisionShape2D = $CollisionShape2D

func _input(event: InputEvent) -> void:
	if event.is_action("Drop"):
		_dropCargo()

func _dropCargo() -> void:
	collider.disabled = true
	await get_tree().create_timer(cargo_drop_time).timeout
	collider.disabled = false
