class_name ScoreUI extends Control

@export var title : String
@export var zone : Types.Zone

@onready var _titleLabel : Label = %TitleLabel
@onready var _counterLabel : Label = %CounterLabel

var _maxScore: float


func _ready() -> void:
	_titleLabel.text = title
	SignalBus.zoneScoreChanged.connect(_onScoreChanged)
	SignalBus.maxScoreSetted.connect(_onMaxScoreSetted)


func _onScoreChanged(targetZone: Types.Zone, value: float) -> void:
	if zone != targetZone:
		return
	_setCounterText(value)

func _onMaxScoreSetted(maxScore: float) ->void:
	_maxScore = maxScore
	_setCounterText(0.0)

func _setCounterText(value: float) -> void:
	_counterLabel.text = str(int(value), "/", int(_maxScore))
