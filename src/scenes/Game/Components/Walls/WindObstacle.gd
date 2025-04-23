class_name WindObstacle extends Node2D
enum windDirection {
	UP,
	DOWN
}

@export var forceDirection: windDirection
@export var blastDuration: float = 6


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

@onready var _bottomParticles: GPUParticles2D = $SpriteMask/BottomParticles
@onready var _topParticles: GPUParticles2D = $SpriteMask/TopParticles
@onready var _audioPlayer : AudioStreamPlayer2D =AudioManager.sfx.createPlayer2D(ResourceIds.SfxId.Wind)


func _ready() -> void:
	activeParticles = _bottomParticles if forceDirection == windDirection.UP else _topParticles
	activeParticles.show()

	add_child(_audioPlayer)
	_audioPlayer.position = Vector2.ZERO

##This should be used to activate the wind tunnel
func Activate(_node: Node2D = null) -> void:
	if _active: return
	_changeParticleSpeed(500)
	_changeParticleQuantity(12)
	_audioPlayer.play(0.0)
	await get_tree().create_timer(0.3,true).timeout
	_active = true
	await get_tree().create_timer(blastDuration,true).timeout
	_active = false
	await get_tree().create_timer(0.3,true).timeout
	_audioPlayer.stop()
	_changeParticleSpeed(80)
	_changeParticleQuantity(8)
		

func _changeParticleSpeed(speed: float) -> void:
	var targetVelocity = activeParticles.process_material.get("initial_velocity")
	targetVelocity.y = speed
	activeParticles.process_material.set("initial_velocity", targetVelocity)

func _changeParticleQuantity(quantity: int) -> void:
	activeParticles.amount = quantity
