class_name WindObstacle extends Node2D
enum windDirection {
	UP,
	DOWN
}

##Apply this force along the line
@export var force: float = 800
@export var platformForceModifier: float = 6
@export var forceDirection: windDirection
@export var blastDuration: float = 6

##Multiplier for the heavier platform
var _platformForce: float:
	get:
		return force * platformForceModifier
##Current bodies within collider
var _bodies: Array[RigidBody2D] = []
var _direction: Vector2:
	get:
		match forceDirection:
			windDirection.UP:
				return Vector2.UP
			windDirection.DOWN:
				return Vector2.DOWN
			_:
				return Vector2.ZERO
var _active: bool = false
var activeParticles: GPUParticles2D

@onready var _area: Area2D = $Area2D
@onready var _bottomParticles: GPUParticles2D = $SpriteMask/BottomParticles
@onready var _topParticles: GPUParticles2D = $SpriteMask/TopParticles
@onready var _audioPlayer : AudioStreamPlayer2D =AudioManager.sfx.createPlayer2D(ResourceIds.SfxId.Wind)


func _ready() -> void:
	_area.body_entered.connect(_addBody)
	###----This is only as a temporary activate-on-enter----
	_area.body_entered.connect(Activate)
	###---------
	_area.body_exited.connect(_removeBody)
	activeParticles = _bottomParticles if forceDirection == windDirection.UP else _topParticles
	activeParticles.show()

	add_child(_audioPlayer)
	_audioPlayer.position = Vector2.ZERO

##This should be used to activate the wind tunnel
func Activate(_node: Node2D = null) -> void:
	if _active: return
	if _bodies.size() <= 0: return
	_changeParticleSpeed(500)
	_changeParticleQuantity(12)
	_audioPlayer.play(0.0)
	await get_tree().create_timer(0.3).timeout
	_active = true
	await get_tree().create_timer(blastDuration).timeout
	_active = false
	await get_tree().create_timer(0.3).timeout
	_audioPlayer.stop()
	_changeParticleSpeed(80)
	_changeParticleQuantity(8)
	
func _addBody(body: Node2D) -> void:
	var groups: Array[StringName] = body.get_groups()
	if groups.has("Player") || groups.has("PlayerPlatform"):
		_bodies.append(body)

func _removeBody(body: Node2D) -> void:
	var groups: Array[StringName] = body.get_groups()
	if (groups.has("Player") || groups.has("PlayerPlatform")) && _bodies.has(body):
		_bodies.erase(body)
		
func _physics_process(_delta: float) -> void:
	if !_active: return
	for body in _bodies:
		var selectedForce = force if body.get_groups().has("Player") else _platformForce
		#body.apply_force(_direction * selectedForce, activeParticles.position)

func _changeParticleSpeed(speed: float) -> void:
	var targetVelocity = activeParticles.process_material.get("initial_velocity")
	targetVelocity.y = speed
	activeParticles.process_material.set("initial_velocity", targetVelocity)

func _changeParticleQuantity(quantity: int) -> void:
	activeParticles.amount = quantity
