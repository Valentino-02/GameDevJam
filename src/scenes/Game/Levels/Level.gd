class_name Level extends Node2D

@export var maxScore : float = 15.0
@export var patienceLossPerSecond : float = 1.0
@export var cargoPatienceGain : float = 10.0
@export var nextLevelId : ResourceIds.LevelId
@export var backgroundScrollCap : float = 9999
@export var activateSecretWin : bool = false


@onready var camera : Camera2D = %Camera2D
@onready var phantomCamera : PhantomCamera2D = %PhantomCamera2D
@onready var tileMapLayers: Array[TileMapLayer] = _getTilemapLayers()
@onready var _boundaryWalls : BoundaryWall = $Layout/BoundaryWalls
@onready var _player : PlayerCharacter = $PlayerCharacter

var Boundaries: BoundaryWall:
	get:
		return _boundaryWalls


func _process(_delta: float) -> void:
#	PlayerRelativePosition.relativePosition = (_player.getPlayerPosition().x - _boundaryWalls.getLeftWallPosition().x)/_boundaryWalls.getLevelWidth()
	
	## NOTE: This is to test a new idea, I think it's working ok!
	PlayerRelativePosition.relativePosition = (camera.get_screen_center_position().x - _boundaryWalls.getLeftWallPosition().x)/_boundaryWalls.getLevelWidth()

func _getTilemapLayers() -> Array[TileMapLayer]:
	var layers: Array[Node] = get_tree().get_nodes_in_group("MovingPlatform")
	var maps: Array[TileMapLayer] = []
	maps.append(%TileMapLayer)
	if layers.size() >= 0:
		for layer in layers:
			maps.append(layer.tilemap)
	return maps
