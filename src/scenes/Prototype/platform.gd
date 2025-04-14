extends RigidBody2D

@onready var collider: CollisionShape2D = get_node("CollisionShape2D")

func _physics_process(delta: float) -> void:
	apply_torque(get_orientation_torque())

@export var orientation_strength : float = 500
func get_orientation_torque() -> float:
	return (0 - rotation) * orientation_strength
	
	
func _input(event: InputEvent) -> void:
	if event.is_action("Drop"):
		_drop_cargo()
		
##duration the platform stays open
@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 2
func _drop_cargo() -> void:
	collider.disabled = true
	await get_tree().create_timer(cargo_drop_time).timeout
	collider.disabled = false