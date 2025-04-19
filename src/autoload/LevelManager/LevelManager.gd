extends Node

@export var levelList : Array[PackedLevel]

var _levelsById: Dictionary[ResourceIds.LevelId , PackedLevel] = {} 
var _targetLevelId : ResourceIds.LevelId


func _ready() -> void:
	for level in levelList:
		_levelsById[level.id] = level


func setTargetLevel(id: ResourceIds.LevelId) -> void:
	_targetLevelId = id

func getTargetLevel() -> PackedScene:
	var packedLevel : PackedLevel = _levelsById.get(_targetLevelId) as PackedLevel
	return packedLevel.levelScene
