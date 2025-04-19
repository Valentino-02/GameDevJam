class_name Game extends Node2D

@onready var _gameUI: GameUI = %GameUI
@onready var _backgroundTextureRect = %BackgroundTextureRect

var _patienceManager := PatienceManager.new()
var _scoreManager := ScoreManager.new()


func _ready() -> void:
	AudioManager.music.play(ResourceIds.MusicId.WindTheme)
	_loadLevel()
	SignalBus.zoneGotCargo.connect(_onZoneGotCargo)
	SignalBus.hazardFixed.connect(_onHazardFix)
	SignalBus.playerEnteredZone.connect(_onPlayerEnteredZone)


func _loadLevel() -> void:
	var level: Level = LevelManager.getTargetLevel().instantiate()
	_scoreManager.setMaxScore(level.maxScore)
	_patienceManager.setPatienceLoss(level.patienceLossPerSecond)
	_patienceManager.setCargoPatienceGain(level.cargoPatienceGain)
	add_child(level)
	await get_tree().process_frame
	_gameUI.setMinimapCamera(level.camera)
	_gameUI.setMinimapTilemaps([level.tileMapLayer])
	_gameUI.drawMinimap()

func _onZoneGotCargo(zone: Types.Zone) -> void:
	_patienceManager.gainPatience(zone)
	_scoreManager.incrementScore(zone)

func _on_timer_timeout() -> void:
	_patienceManager.triggerPatienceLoss()

func _onHazardFix(hazard: Types.Element) -> void:
	var zone = Types.Zone.Left if hazard == Types.Element.Water else Types.Zone.Right
	_patienceManager.gainPatience(zone)

func _onPlayerEnteredZone(zone: Types.Zone) -> void:
	var target_color: Color
	var music_id
	match zone:
		Types.Zone.Left:
			music_id = ResourceIds.MusicId.WaterTheme
			target_color = Color("2e45da")
		Types.Zone.Middle:
			music_id = ResourceIds.MusicId.WindTheme
			target_color = Color("ffffff")
		Types.Zone.Right:
			music_id = ResourceIds.MusicId.FireTheme
			target_color = Color("aa1d2c")

	AudioManager.music.crossFadeTo(music_id)
	var tween = create_tween()
	tween.tween_property(_backgroundTextureRect, "modulate", target_color, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
