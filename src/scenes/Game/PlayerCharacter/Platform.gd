extends RigidBody2D

@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5

@onready var _animator: AnimationPlayer = $AnimationPlayer
@onready var _staticPlatform: Node2D = $StaticPlatform
@onready var _animatedPlatform: Node2D = $AnimatedPlatform
@onready var _staticPlatformCollider: CollisionShape2D = $StaticPlatformCollider
@onready var _leftPlatformCollider: CollisionShape2D = $LeftPlatformCollider
@onready var _rightPlatformCollider: CollisionShape2D = $RightPlatformCollider
@onready var _lplayer : Character = get_node("../LeftCharacter")
@onready var _rplayer : Character = get_node("../RightCharacter")

signal _dropRelease

func _physics_process(delta: float) -> void:
	self.gravity_scale = 0.0 if _noPlayerInput() else 0.6
func _noPlayerInput() -> bool:
	return _lplayer.outputDir == Vector2.ZERO and _rplayer.outputDir == Vector2.ZERO

var _dropping: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action("Drop"):
		_dropCargo()
	if event.is_action_released("Drop"):
		if _animator.is_playing():
			await _animator.animation_finished
		_dropRelease.emit()

func _dropCargo() -> void:
	if _dropping: return
	_dropping = true
	_open()
	await _dropRelease
	await _close()
	_dropping = false

	
func _cargoDoors(open:bool) -> void:
	var animationName = "openDoors" if open else "closeDoors"
	_animator.play(animationName)
	
func _open() -> void:
	_leftPlatformCollider.disabled = false
	_rightPlatformCollider.disabled = false
	_staticPlatformCollider.disabled = true
	_animatedPlatform.show()
	_staticPlatform.hide()
	_cargoDoors(true)
	
func _close() -> void:
	_cargoDoors(false)
	await _animator.animation_finished
	_staticPlatformCollider.disabled = false	
	_leftPlatformCollider.disabled = true
	_rightPlatformCollider.disabled = true
	_staticPlatform.show()
	_animatedPlatform.hide()
	set_collision_layer_value(4, true)
