@tool
class_name WindObstacle extends Node2D
enum windDirection {
	UP,
	DOWN
}

@export var forceDirection: windDirection
@export var blastDuration: float = 6
@export var area: Shape2D:
	set(value):
		area = value
		area.changed.connect(_updateArea)
@export var activate: bool:
	set(value):
		activate = false
		Activate()

signal sizeChanged

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
@onready var _cooldownTimer : Timer = %CooldownTimer

func _ready() -> void:
	if Engine.is_editor_hint(): return
	activeParticles = _bottomParticles if forceDirection == windDirection.UP else _topParticles
	activeParticles.show()

	add_child(_audioPlayer)
	_audioPlayer.position = Vector2.ZERO

##This should be used to activate the wind tunnel
func Activate(_node: Node2D = null) -> void:
	if Engine.is_editor_hint(): return
	if _active: return
	_changeParticleSpeed(500)
	_changeParticleQuantity(80)
	_audioPlayer.play(0.0)
	await get_tree().create_timer(0.3,true).timeout
	_active = true
	await get_tree().create_timer(blastDuration,true).timeout
	_active = false
	await get_tree().create_timer(0.3,true).timeout
	_audioPlayer.stop()
	_changeParticleSpeed(80)
	_changeParticleQuantity(30)
	_cooldownTimer.start()
	
		

func _changeParticleSpeed(speed: float) -> void:
	var targetVelocity = activeParticles.process_material.get("initial_velocity")
	targetVelocity.y = speed
	activeParticles.process_material.set("initial_velocity", targetVelocity)

func _changeParticleQuantity(quantity: int) -> void:
	activeParticles.amount = quantity

func _on_cooldown_timer_timeout() -> void:
	Activate()

func _updateArea() -> void:
	var _collisionShape = $Area2D/CollisionShape2D
	_collisionShape.shape = area
	var _mask = $SpriteMask
	var texture:AtlasTexture = _mask.texture as AtlasTexture
	texture.region = area.get_rect()
	var height:float = area.get_rect().size.y/2
	var width:float = area.get_rect().size.x/2
	_bottomParticles.position = Vector2(0,0)
	_topParticles.position = Vector2(0,-0)
	var boxExtents:Vector3 = Vector3(width,height,0)
	_bottomParticles.process_material.set("emission_box_extents",boxExtents)
	_topParticles.process_material.set("emission_box_extents",boxExtents)
	var rect: Rect2 = Rect2(-width,-height,width*2,height*2)
	_bottomParticles.visibility_rect = rect
	_topParticles.visibility_rect = rect
	