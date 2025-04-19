class_name Level extends Node2D

@export var maxScore : float = 15.0
@export var patienceLossPerSecond : float = 1.0
@export var cargoPatienceGain : float = 10.0

@onready var camera : Camera2D = %Camera2D
@onready var tileMapLayer : TileMapLayer = %TileMapLayer
