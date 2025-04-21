extends RigidBody2D

@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5

@onready var _animator: AnimationPlayer = $AnimationPlayer
@onready var _staticPlatform: Node2D = $Sprite2D
@onready var _animatedPlatform: Node2D = $AnimatedPlatform
@onready var _lplayer : Character = get_node("../LeftCharacter")
@onready var _rplayer : Character = get_node("../RightCharacter")

func _physics_process(delta: float) -> void:
	self.gravity_scale = 0.0 if _noPlayerInput() else 0.6
func _noPlayerInput() -> bool:
	return _lplayer.outputDir == Vector2.ZERO and _rplayer.outputDir == Vector2.ZERO

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
	set_collision_layer_value(4, false)
	_animatedPlatform.show()
	_staticPlatform.hide()
	_cargoDoors(true)
	
func _close() -> void:
	_cargoDoors(false)
	await _animator.animation_finished
	_staticPlatform.show()
	_animatedPlatform.hide()
	set_collision_layer_value(4, true)
