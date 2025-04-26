class_name Platform extends RigidBody2D

@export_custom(PROPERTY_HINT_NONE,"suffix:s") var cargo_drop_time: float = 1.5

@onready var _leftPlatformCollider: CollisionShape2D = $LeftPlatformCollider
@onready var _rightPlatformCollider: CollisionShape2D = $RightPlatformCollider
@onready var _leftSprite : Node2D = get_node("Left Attachment")
@onready var _rightSprite : Node2D = get_node("Right Attachment")
@onready var _lplayer : Character = get_node("../LeftCharacter")
@onready var _rplayer : Character = get_node("../RightCharacter")
@onready var _lHbox : Area2D = get_node("Left Attachment/Area2D")
@onready var _rHbox : Area2D = get_node("Right Attachment/Area2D")

var _currentAngle : float = 0
const MAX_ANGLE : float =  PI / 2.2
const OPEN_SPEED : float = PI / 1.4
const CLOSE_SPEED : float = -PI / 2.5
const LIFT_FORCE : float = 500

func _physics_process(delta: float) -> void:
	self.gravity_scale = 0.0 if _noPlayerInput() else 0.8
	if Input.is_action_pressed("Drop"):
		_rotateCargoDoors(OPEN_SPEED * delta)
		toggleGravity(false)
	elif _currentAngle > 0: #If we aren't trying to open, then try to close
		_applyCrateLift()
		_rotateCargoDoors(CLOSE_SPEED * delta)
	else:
		toggleGravity(false)

	_negateLoad()
		

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

func toggleGravity(enabled : bool):
	var value : Area2D.SpaceOverride = Area2D.SPACE_OVERRIDE_REPLACE if enabled else Area2D.SPACE_OVERRIDE_DISABLED
	_lHbox.gravity_space_override = value
	_rHbox.gravity_space_override = value
	

##Maybe apply a little help to crates in the middle so that they can get picked up more easily?
func _applyCrateLift():
	toggleGravity(true)
	var lcargo = _lHbox.get_overlapping_bodies()
	var rcargo = _rHbox.get_overlapping_bodies()
	var both = lcargo.filter(func (x): return rcargo.has(x))
	lcargo = lcargo.filter(func (x): return not both.has(x))
	rcargo = rcargo.filter(func (x): return not both.has(x))
	for cargo in both:
		if cargo is Cargo:
			cargo.apply_force(Vector2.UP * LIFT_FORCE)
	for cargo in lcargo:
		if cargo is Cargo:
			cargo.apply_force(Vector2.UP * LIFT_FORCE)#.rotated(_currentAngle / 2.0) * LIFT_FORCE)
	for cargo in rcargo:
		if cargo is Cargo:
			cargo.apply_force(Vector2.UP * LIFT_FORCE)#.rotated(-_currentAngle / 2.0) * LIFT_FORCE)

func _negateLoad():
	var checked : Array[Cargo] = []
	for cargo in get_colliding_bodies():
		if cargo is Cargo:
			checked.append(cargo)
			_getGravityRec(cargo, checked)

func _getGravityRec(node : Cargo, checked : Array[Cargo] ):
	for cargo in node.get_colliding_bodies():
		if cargo is Cargo and not checked.has(cargo):
			checked.append(cargo)
			_getGravityRec(node, checked)
	self.apply_force(node.mass * node.get_gravity() * -0.95, node.global_position - self.global_position)
