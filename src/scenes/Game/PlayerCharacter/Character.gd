class_name Character extends Area2D


@export var orientationStrength: float = 5000

@export var _suffix: String = "L"
@export var _rope: Rope
@export var element: Types.Element

@export var _radius : float = 50
@export var _speed : float = 200
@export var returnSpeed : float = 200
var outputDir : Vector2 = Vector2.ZERO
const STRUCK_TIME : int = 100
var _struck : int = Time.get_ticks_msec() - STRUCK_TIME
var _struckDir : Vector2 = Vector2.ZERO
const STRUCK_SPEED : float = 150
@onready var _origin : Marker2D = get_node("../"+_suffix + "Origin")

func _ready() -> void:
	var _particles: CPUParticles2D = $GPUParticles2D
	_particles.emitting = true
	#_rope.springLength = _origin.global_position.distance_to(_rope.platform_attachement.global_position)
	_origin.global_position = _rope.platform_attachement.global_position + Vector2.UP * _rope.springLength
	SignalBus.zonePatienceEnded.connect(_onZonePatienceEnded)
	SignalBus.bothScoreMaxed.connect(_onBothScoreMaxed)

var _previousValidPosition
#get the target position = back to origin or current position + speed in input direciton
func _physics_process(delta: float) -> void:
	if _outsideBoundary():
		global_position = _previousValidPosition
		outputDir = Vector2.ZERO
		return
	else:
		_previousValidPosition = global_position

	var inputDir : Vector2 = _getInputVector()
			
	_origin.global_position = _rope.platform_attachement.global_position + Vector2.UP * _rope.springLength
	var origin : Vector2 = _origin.global_position

	#if in an up wind tunnel:
	if _inWind():
		origin += Vector2.UP * _radius * 0.55
	if _inRainCloud(): 
		origin += Vector2.DOWN * _radius * 0.55
	
	

	#move towards the joystick's origin if no input, otherwise go with the input
	if inputDir == Vector2.ZERO:
		var distance : float = global_position.distance_to(origin)
		global_position = global_position.lerp(origin, clampf((returnSpeed * delta)/distance, 0, 1))
	else:global_position += _speed * delta * inputDir

	#If beyond the radius, move back to within
	var difference : Vector2 = (global_position - origin)
	global_position = origin + difference.limit_length(_radius)
	
	outputDir = global_position - _origin.global_position

	#If we were struck by a fireball push us in that direction
	if (Time.get_ticks_msec() < _struck + STRUCK_TIME):
		global_position += _struckDir * STRUCK_SPEED * delta 

	

	
func _getInputVector() -> Vector2:
	var input_vector: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("Right " + _suffix):
		input_vector.x += 1
	if Input.is_action_pressed("Left " + _suffix):
		input_vector.x -= 1
	if Input.is_action_pressed("Down " + _suffix):
		input_vector.y += 1
	if Input.is_action_pressed("Up " + _suffix):
		input_vector.y -= 1
	
	return input_vector.normalized()


static func getComponentAlongDirection(force: Vector2, direction: Vector2) -> Vector2:
	return (max(force.dot(direction), 0) * direction)

func _inRainCloud() -> bool:
	for area in get_overlapping_areas():
		if (element == Types.Element.Fire and area.get_parent() is RainCloud and area.get_parent()._raining) or (area.get_parent() is WindObstacle and area.get_parent().forceDirection == WindObstacle.windDirection.DOWN and area.get_parent()._active):
			return true
	return false

func _inWind() -> bool:
	for area in get_overlapping_areas():
		if area.get_parent() is WindObstacle and area.get_parent().forceDirection == WindObstacle.windDirection.UP and area.get_parent()._active:
			return true
	return false

func _collideArea(area):
	if area is Fireball:
		if element == Types.Element.Fire:
			area.explosion_strength *= 0.5
			area._shape_cast.shape.radius *= 0.5
			area._onCollision(self)
		else:
			area.explosion_strength *= 2
			area._shape_cast.shape.radius *= 2
			area._onCollision(self)
			

func _onFireball(direction : Vector2):
	_struck = Time.get_ticks_msec()
	_struckDir = direction

		#need to do something here to ensure we don't leave the boundary, but implementing move and slide is so tedious

func _onZonePatienceEnded(_zone : Types.Zone) -> void:
	set_physics_process(false)

func _onBothScoreMaxed() -> void:
	set_physics_process(false)

func _outsideBoundary() -> bool:
	return get_overlapping_bodies().any(func (x): return x.get_parent() is BoundaryWall)
