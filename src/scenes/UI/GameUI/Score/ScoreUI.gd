class_name ScoreUI extends Control

@export var title : String
@export var zone : Types.Zone
@export var fireFlash : Color = Color("#FF4C4C")  
@export var waterFlash : Color = Color("#4CB2FF")  

@onready var _titleLabel : Label = %TitleLabel
@onready var _counterLabel : Label = %CounterLabel

var _maxScore: float
var _startingPosition : Vector2


func _ready() -> void:
	_titleLabel.text = title
	SignalBus.zoneScoreChanged.connect(_onScoreChanged)
	SignalBus.maxScoreSetted.connect(_onMaxScoreSetted)
	await self.ready 
	await get_tree().process_frame 
	_startingPosition = position


func _onScoreChanged(targetZone: Types.Zone, value: float) -> void:
	if zone != targetZone:
		return
	_setCounterText(value)
	_onScoreAnimation()

func _onMaxScoreSetted(maxScore: float) ->void:
	_maxScore = maxScore
	_setCounterText(0.0)

func _setCounterText(value: float) -> void:
	_counterLabel.text = str(int(value), "/", int(_maxScore))

func _onScoreAnimation():
	var paralelTween := create_tween()
	paralelTween.set_parallel(true)
	var tween := create_tween()
	var originalColor := Color.WHITE
	_titleLabel.modulate = fireFlash if zone == Types.Zone.Right else waterFlash
	paralelTween.tween_property(_titleLabel, "modulate", originalColor, 1.0).set_ease(Tween.EASE_IN)
	paralelTween.tween_property(_counterLabel, "modulate", originalColor, 1.0).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", _startingPosition + Vector2(4, 0), 0.05)
	tween.tween_property(self, "position", _startingPosition - Vector2(4, 0), 0.05)
	tween.tween_property(self, "position", _startingPosition + Vector2(0, 4), 0.05)
	tween.tween_property(self, "position", _startingPosition - Vector2(0, 4), 0.05)
	tween.tween_property(self, "position", _startingPosition, 0.05)
