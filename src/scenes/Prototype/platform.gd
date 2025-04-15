extends RigidBody2D

func _physics_process(delta: float) -> void:
	#apply_torque(get_orientation_torque())
	#clamp_rotation()
	pass

##Could be used to reduce difficulty, a restoring force to help balance
@export var orientation_strength : float = 500
func get_orientation_torque() -> float:
	return (0 - rotation) * orientation_strength


##Inetria breaks everything, this is a manual version, but I don't think it works
@export var angular_dampen_strength : float = 10000
func clamp_rotation():
	apply_torque(-angular_dampen_strength * angular_velocity * mass)


func _input(event: InputEvent) -> void:
	if event.is_action("Drop"):
		_drop_cargo()

##duration the platform stays open
@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5
@onready var collider: CollisionShape2D = get_node("CollisionShape2D")
func _drop_cargo() -> void:
	collider.disabled = true
	await get_tree().create_timer(cargo_drop_time).timeout
	collider.disabled = false