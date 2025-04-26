class_name PlayerCharacter extends Node2D

@onready var _leftCharacter : Character = %LeftCharacter
@onready var _rightCharacter : Character = %RightCharacter

func getPlayerPosition() -> Vector2:
	return (_rightCharacter.global_position + _leftCharacter.global_position)/2.0

func _physics_process(delta: float) -> void:
	stayInPlace(delta)

func stayInPlace(delta : float):
	if _rightCharacter.outputDir.length() >= _rightCharacter._radius * 0.9 and _leftCharacter.outputDir != Vector2.ZERO:
		_rightCharacter.moveInput(delta, -0.5 * _leftCharacter.outputDir / _leftCharacter._radius)
		_rightCharacter.remainRadius(_rightCharacter._origin.global_position)
	if _leftCharacter.outputDir.length() >= _leftCharacter._radius * 0.9 and _rightCharacter.outputDir != Vector2.ZERO:
		_leftCharacter.moveInput(delta, -0.5 * _rightCharacter.outputDir / _leftCharacter._radius)
		_leftCharacter.remainRadius(_leftCharacter._origin.global_position)
		
