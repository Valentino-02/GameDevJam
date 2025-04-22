class_name Level extends Node2D

@export var maxScore : float = 15.0
@export var patienceLossPerSecond : float = 1.0
@export var cargoPatienceGain : float = 10.0
@export var nextLevelId : ResourceIds.LevelId
@export var activateSecretWin : bool = false

@onready var camera : Camera2D = %Camera2D
@onready var phantomCamera : PhantomCamera2D = %PhantomCamera2D
@onready var tileMapLayers: Array[TileMapLayer] = _getTilemapLayers()

func _getTilemapLayers() -> Array[TileMapLayer]:
	var layers: Array[Node] = get_tree().get_nodes_in_group("MovingPlatform")
	var maps: Array[TileMapLayer] = []
	maps.append(%TileMapLayer)
	if layers.size() >= 0:
		for layer in layers:
			maps.append(layer.tilemap)
	return maps
