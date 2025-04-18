class_name Level extends Node2D

signal readyFinished 

@export var maxScore : float = 15.0

@onready var camera : Camera2D = %Camera2D
@onready var tileMapLayer : TileMapLayer = %TileMapLayer
