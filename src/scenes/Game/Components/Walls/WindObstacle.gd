class_name WindObstacle extends Node2D
enum windDirection {
	UP,
	DOWN
}

@export var forceDirection: windDirection
@export var blastDuration: float = 6
const  FORCE_STRENGTH = 50

@export var activate: bool:
	set(value):
		activate = false
		Activate()

@onready var _area : Area2D = get_node("Area2D")
@onready var _collisionShape : CollisionShape2D = get_node("Area2D/CollisionShape2D")


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
var activeParticles: CPUParticles2D


@onready var _bottomParticles: CPUParticles2D = $SpriteMask/BottomParticles
@onready var _topParticles: CPUParticles2D = $SpriteMask/TopParticles
var _audioPlayer: AudioStreamPlayer2D 
@onready var _cooldownTimer: Timer = %CooldownTimer

func _ready() -> void:
	if Engine.is_editor_hint(): return
	#_updateArea()
	_audioPlayer = AudioManager.sfx.createPlayer2D(ResourceIds.SfxId.Wind)
	activeParticles = _bottomParticles if forceDirection == windDirection.UP else _topParticles
	activeParticles.show()
	add_child(_audioPlayer)
	_audioPlayer.position = Vector2.ZERO

##This should be used to activate the wind tunnel
func Activate(_node: Node2D = null) -> void:
	if Engine.is_editor_hint(): return
	if _active: return
	_changeParticleSpeed(700)
	_changeParticleQuantity(150)
	_audioPlayer.volume_db = Settings.MIN_VOLUME

	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_audioPlayer, "volume_db", AudioManager.sfx._sfxById.get(ResourceIds.SfxId.Wind).volume, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_audioPlayer.play(0.0)
	await get_tree().create_timer(0.3, true).timeout

	_active = true
	_area.gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE

	await get_tree().create_timer(blastDuration, true).timeout
	
	_active = false
	_area.gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED

	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_audioPlayer, "volume_db", Settings.MIN_VOLUME, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(0.3, true).timeout
	_audioPlayer.stop()
	_changeParticleSpeed(80)
	_changeParticleQuantity(50)
	_cooldownTimer.start()
	

func _physics_process(delta: float) -> void:
	if _active:
		for body in _area.get_overlapping_bodies():
			if body is RigidBody2D:
				body.apply_central_force(_direction * FORCE_STRENGTH)

func _changeParticleSpeed(speed: float) -> void:
	activeParticles.initial_velocity_min = speed
	activeParticles.initial_velocity_max = speed * 1.2


func _changeParticleQuantity(quantity: int) -> void:
	activeParticles.amount = quantity

func _on_cooldown_timer_timeout() -> void:
	Activate()

func _updateArea() -> void:
	var shape = _collisionShape.shape
	var _mask = $SpriteMask
	var texture: AtlasTexture = _mask.texture as AtlasTexture
	texture.region = shape.get_rect()
	var height: float = shape.get_rect().size.y / 2
	var width: float = shape.get_rect().size.x / 2
	_bottomParticles.position = Vector2(0, 0)
	_topParticles.position = Vector2(0, -0)
	var boxExtents: Vector3 = Vector3(width, height, 0)
	_bottomParticles.process_material.set("emission_box_extents", boxExtents)
	_topParticles.process_material.set("emission_box_extents", boxExtents)
	var rect: Rect2 = Rect2(-width, -height, width * 2, height * 2)
	_bottomParticles.visibility_rect = rect
	_topParticles.visibility_rect = rect
