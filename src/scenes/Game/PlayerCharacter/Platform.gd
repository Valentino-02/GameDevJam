extends RigidBody2D

@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5

@onready var _leftPlatformCollider: CollisionShape2D = $LeftPlatformCollider
@onready var _rightPlatformCollider: CollisionShape2D = $RightPlatformCollider
@onready var _leftSprite : Sprite2D = get_node("LeftPlatform")
@onready var _rightSprite : Sprite2D = get_node("RightPlatform")
@onready var _lplayer : Character = get_node("../LeftCharacter")
@onready var _rplayer : Character = get_node("../RightCharacter")

var _currentAngle : float = 0
const MAX_ANGLE : float =  PI / 2.2
const OPEN_SPEED : float = PI / 1.2
const CLOSE_SPEED : float = -PI / 2.5

func _physics_process(delta: float) -> void:
	self.gravity_scale = 0.0 if _noPlayerInput() else 0.6
	if Input.is_action_pressed("Drop"):
		_rotateCargoDoors(OPEN_SPEED * delta)
	elif _currentAngle > 0: #If we aren't trying to open, then try to close
		_rotateCargoDoors(CLOSE_SPEED * delta)

##keep the animation as close doors, if we want to drop, play in reverse until we want to resume...?

func _noPlayerInput() -> bool:
	return _lplayer.outputDir == Vector2.ZERO and _rplayer.outputDir == Vector2.ZERO

func _rotateCargoDoors(angleDelta : float):
	_currentAngle = clampf( _currentAngle + angleDelta, 0, MAX_ANGLE)
	_setRotations(_currentAngle)

func _setRotations(angle : float):
	_leftPlatformCollider.rotation = angle
	_rightPlatformCollider.rotation = -angle
	_leftSprite.rotation = angle
	_rightSprite.rotation = -angle

##Maybe apply a little help to crates in the middle so that they can get picked up more easily?
func _applyCrateLift():
	pass 