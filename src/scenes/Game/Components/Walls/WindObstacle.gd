extends Node2D

##Apply this force along the line
@export var force: float = 100
@export var platformForceModifier: float = 3

var _platformForce: float: 
	get: 
		return force*platformForceModifier

var _bodies: Array[RigidBody2D] = []
var _direction: Vector2:
	get:
		return position.direction_to(_targetPoint.position)
		
@onready var _targetPoint: Marker2D = $Marker2D
@onready var _area: Area2D = $Area2D
@onready var _directionalLine: Line2D = $Line2D

func _ready() -> void:
	_directionalLine.hide()
	_area.body_entered.connect(_addBody)
	_area.body_exited.connect(_removeBody)
	SignalBus.restart.connect(_reset)
	
func _physics_process(_delta: float) -> void:
	_applyForce()
	
func _reset() -> void:
	_bodies = []
	
func _addBody(body: Node2D) -> void:
	print(body.name)
	var groups: Array[StringName] = body.get_groups()
	if groups.has("Player") || groups.has("PlayerPlatform"):
		_bodies.append(body)

func _removeBody(body:Node2D) -> void:
	var groups: Array[StringName] = body.get_groups()
	if (groups.has("Player") || groups.has("PlayerPlatform")) && _bodies.has(body):
		_bodies.erase(body)
		
func _applyForce() -> void:
	if _bodies.size() <= 0: return
	for body in _bodies: 
		var selectedForce = force if body.get_groups().has("Player") else _platformForce
		body.apply_force(_direction*selectedForce)