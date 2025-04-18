extends RigidBody2D

@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5

@onready var _collider: CollisionShape2D = $CollisionShape2D
@onready var _animator: AnimationPlayer = $AnimationPlayer
@onready var _staticPlatform: Node2D = $Sprite2D
@onready var _animatedPlatform: Node2D = $AnimatedPlatform

var _dropping: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action("Drop"):
		_dropCargo()

func _dropCargo() -> void:
	if _dropping: return
	_dropping = true
	_open()
	await get_tree().create_timer(cargo_drop_time).timeout
	await _close()
	_dropping = false

	
func _cargoDoors(open:bool) -> void:
	var animationName = "openDoors" if open else "closeDoors"
	_animator.play(animationName)
	
func _open() -> void:
	_collider.disabled = true
	_animatedPlatform.show()
	_staticPlatform.hide()
	_cargoDoors(true)
	
func _close() -> void:
	_cargoDoors(false)
	await _animator.animation_finished
	_staticPlatform.show()
	_animatedPlatform.hide()
	_collider.disabled = false