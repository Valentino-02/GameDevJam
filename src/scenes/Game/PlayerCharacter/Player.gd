class_name PlayerCharacter extends Node2D

##Player's move force
@export var strength: float = 400.0
##How much the player can stretch the rope before inputs get ignored
@export var leashMultiplier : float = 1.3
##When exceeding the leash distance, player_dampening * relative velocity acts as a restorative force.
@export var dampening : float = 2
##How much the upwards lift should be added in order to counteract gravity, 1 is no additional lift, 0 is no lift at all
@export var liftMultiplier : float = 3

@onready var _leftRope: Rope = %LeftRope
@onready var _rightRope: Rope = %RightRope
@onready var _leftCharacter: Character = %LeftCharacter
@onready var _rightCharacter: Character = %RightCharacter


func _physics_process(_delta: float) -> void:
	_handleCharacterMovement()


func _handleCharacterMovement() -> void:
	for suffix in ["L", "R"]:
		##Select the correct character and rope
		var character : Character = _rightCharacter
		var rope : Rope = _rightRope
		var force : Vector2 = _getInputVector(suffix) * strength
		if suffix == "L":
			character = _leftCharacter
			rope = _leftRope

		##adds extra lift
		force += getComponentAlongDirection(force, Vector2.UP) * (liftMultiplier - 1)

		##Dampen the input and the velocity if the rope is too stretched
		var difference : Vector2 = character.global_position - rope.platform_attachement.global_position
		var direction : Vector2 = difference.normalized()
		if difference.length() > rope.springLength * leashMultiplier:
			force -= getComponentAlongDirection(force, direction)
		force -= getComponentAlongDirection(character.linear_velocity, direction) * dampening
		character.apply_force(force)

func _getInputVector(suffix : String) -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("Right " + suffix):
		input_vector.x += 1
	if Input.is_action_pressed("Left " + suffix):
		input_vector.x -= 1
	if Input.is_action_pressed("Down " + suffix):
		input_vector.y += 1
	if Input.is_action_pressed("Up " + suffix):
		input_vector.y -= 1

	return input_vector.normalized()

static func getComponentAlongDirection(force: Vector2, direction : Vector2) -> Vector2:
	return (max(force.dot(direction), 0) * direction)
