class_name Game extends Node2D

@onready var _gameUI : GameUI = %GameUI

var _patienceManager := PatienceManager.new()
var _scoreManager := ScoreManager.new()


func _ready() -> void:
	_loadLevel()
	SignalBus.zoneGotCargo.connect(_onZoneGotCargo)
	AudioManager.music.play(ResourceIds.MusicId.MainTheme)


func _loadLevel() -> void:
	var level : Level = LevelManager.getTargetLevel().instantiate()
	_scoreManager.setMaxScore(level.maxScore)
	add_child(level)
	await get_tree().process_frame
	_gameUI.setMinimapCamera(level.camera)
	var tilemaps : Array[TileMapLayer] = []
	tilemaps.append(level.tileMapLayer)
	_gameUI.setMinimapTilemaps(tilemaps)
	

func _onZoneGotCargo(zone: Types.Zone) -> void:
	_patienceManager.gainPatience(zone)
	_scoreManager.incrementScore(zone)

func _on_timer_timeout() -> void:
	_patienceManager.triggerPatienceLoss()
