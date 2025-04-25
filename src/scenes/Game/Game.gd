class_name Game extends Node2D

@onready var _gameUI: GameUI = %GameUI
@onready var _backgroundTextureRect: TextureRect = %BackgroundTextureRect
@onready var _parallax: Node2D = %Parallax2DGroup

var _patienceManager := PatienceManager.new()
var _scoreManager := ScoreManager.new()
var _level: Level
var _maxBackgroundScroll = 895

var _zoneTransitionTweens: Array[Tween] = []

var Camera: Camera2D:
	get:
		return _level.get_node("Camera2D")

var Boundaries: BoundaryWall:
	get:
		return _level.Boundaries

func _ready() -> void:
	AudioManager.music.play(ResourceIds.MusicId.WindTheme)
	_loadLevel()
	SignalBus.zoneGotCargo.connect(_onZoneGotCargo)
	SignalBus.hazardFixed.connect(_onHazardFix)
	SignalBus.playerEnteredZone.connect(_onPlayerEnteredZone)
	SignalBus.zonePatienceEnded.connect(_onZonePatienceEnded)
	SignalBus.nextLevelClicked.connect(_onNextLevelClicked)
	SignalBus.bothScoreMaxed.connect(_onBothScoreMaxed)

func _process(_delta: float) -> void:
	updateBackgroundPosition()

func updateBackgroundPosition() -> void:
	var center_offset = _maxBackgroundScroll * 0.5
	var allowed_scroll = min(_level.backgroundScrollCap, center_offset)
#	var relativePosition = PlayerRelativePosition.cutscenePosition if CutsceneManager.Running else PlayerRelativePosition.relativePosition
	var relativePosition = PlayerRelativePosition.relativePosition
	var offset = relativePosition * _maxBackgroundScroll
	_backgroundTextureRect.position.x = - clamp(offset, center_offset - allowed_scroll, center_offset + allowed_scroll)

func _loadLevel() -> void:
	var level: Level = LevelManager.getTargetLevel().instantiate()
	_scoreManager.setMaxScore(level.maxScore)
	_patienceManager.setPatienceLoss(level.patienceLossPerSecond)
	_patienceManager.setCargoPatienceGain(level.cargoPatienceGain)
	_level = level
	add_child(level)
	await get_tree().process_frame
	SignalBus.levelLoaded.emit()
	_gameUI.setMinimapCamera(level.camera)
	_gameUI.setMinimapTilemaps(level.tileMapLayers)
	_gameUI.drawMinimap()

func _onNextLevelClicked() -> void:
	LevelManager.setTargetLevel(_level.nextLevelId)
	AudioManager.music.stop()
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)

func _onZoneGotCargo(zone: Types.Zone) -> void:
	_patienceManager.gainPatience(zone)
	_scoreManager.incrementScore(zone)

func _onBothScoreMaxed() -> void:
	AudioManager.music.stop()
	var tween = create_tween()
	tween.tween_property(_level, "position", Vector2(10, 0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(_level, "position", Vector2(-10, 0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(_level.phantomCamera, "zoom", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	_gameUI.openWinScreen()

func _onZonePatienceEnded(zone: Types.Zone) -> void:
	AudioManager.music.stop()
	var target_color: Color
	if zone == Types.Zone.Left:
		target_color = Color("6e120c")
	if zone == Types.Zone.Right:
		target_color = Color("051183")
	var colourTween = create_tween()
	colourTween.set_parallel(true)
	colourTween.tween_property(_backgroundTextureRect, "modulate", target_color, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	colourTween.tween_property(_level, "modulate", target_color, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	colourTween.tween_property(_parallax, "modulate", target_color, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var posTween = create_tween()
	posTween.tween_property(_level, "position", Vector2(40, 0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	posTween.tween_property(_level, "position", Vector2(-40, 0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	posTween.tween_property(_level, "position", Vector2(30, 0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	posTween.tween_property(_level, "position", Vector2(-30, 0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	posTween.tween_property(_level, "position", Vector2(20, 0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	posTween.tween_property(_level, "position", Vector2(-20, 0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await posTween.finished
	_gameUI.openLoseScreen(_level.activateSecretWin)

func _on_timer_timeout() -> void:
	_patienceManager.triggerPatienceLoss()

func _onHazardFix(hazard: Types.Element) -> void:
	var zone = Types.Zone.Left if hazard == Types.Element.Water else Types.Zone.Right
	_patienceManager.gainPatience(zone)

func _onPlayerEnteredZone(zone: Types.Zone) -> void:
	var target_color: Color
	var music_id: ResourceIds.MusicId
	match zone:
		Types.Zone.Left:
			music_id = ResourceIds.MusicId.FireTheme
			target_color = Color("81543f")
		Types.Zone.Middle:
			music_id = ResourceIds.MusicId.WindTheme
			target_color = Color("857a7a")
		Types.Zone.Right:
			music_id = ResourceIds.MusicId.WaterTheme
			target_color = Color("5a80ab")

	if _zoneTransitionTweens.size() > 0:
		for tween in _zoneTransitionTweens:
			if tween is Tween: tween.kill()
		_zoneTransitionTweens = []
	
	_zoneTransitionTweens = AudioManager.music.crossFadeTo(music_id)
	var tween: Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(_backgroundTextureRect, "modulate", target_color, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(_parallax, "modulate", target_color, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_zoneTransitionTweens.append(tween)
