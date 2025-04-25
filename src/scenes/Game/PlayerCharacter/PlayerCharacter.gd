class_name PlayerCharacter extends Node2D

@onready var _leftCharacter : Character = %LeftCharacter
@onready var _rightCharacter : Character = %RightCharacter

func getPlayerPosition() -> Vector2:
	return (_rightCharacter.global_position + _leftCharacter.global_position)/2.0
