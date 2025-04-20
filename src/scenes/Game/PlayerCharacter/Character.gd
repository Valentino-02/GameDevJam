class_name Character extends Node2D


@export var orientationStrength: float = 5000

@export var _suffix: String = "L"
@export var _rope: Rope
@export var element: Types.Element

@export var _radius : float = 50
@export var _speed : float = 200
@export var returnSpeed : float = 200
var outputDir : Vector2

@onready var _origin : Marker2D = get_node("../"+_suffix + "Origin")

func _ready() -> void:
	var _particles: GPUParticles2D = $GPUParticles2D
	_particles.emitting = true
	#_rope.springLength = _origin.global_position.distance_to(_rope.platform_attachement.global_position)
	_origin.global_position = _rope.platform_attachement.global_position + Vector2.UP * _rope.springLength
	



#get the target position = back to origin or current position + speed in input direciton
func _physics_process(delta: float) -> void:
	var inputDir : Vector2 = _getInputVector()
	_origin.global_position = _rope.platform_attachement.global_position + Vector2.UP * _rope.springLength
	var origin : Vector2 = _origin.global_position

	#move towards the joystick's origin if no input
	if inputDir == Vector2.ZERO:
		var distance : float = global_position.distance_to(origin)
		global_position = global_position.lerp(origin, clampf((returnSpeed * delta)/distance, 0, 1))

	else:
		global_position += _speed * delta * inputDir
		#global_position = global_position.lerp(target, ())

	#If beyond the radius, move back to within
	var difference : Vector2 = (global_position - origin)
	global_position = origin + difference.limit_length(_radius)
	
	outputDir = global_position - origin


	
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
