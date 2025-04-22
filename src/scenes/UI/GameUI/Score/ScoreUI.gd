class_name ScoreUI extends Control

@export var zone : Types.Zone
@export var fireFlash : Color = Color("#FF4C4C")  
@export var waterFlash : Color = Color("#4CB2FF")  

@onready var _titleLabel : Label = %TitleLabel
@onready var _counterLabel : Label = %CounterLabel

var _maxScore: float
var _startingPosition : Vector2


func _ready() -> void:
	_titleLabel.text = "We Need Water!" if zone == Types.Zone.Left else "We Need Fire!"
	SignalBus.zoneScoreChanged.connect(_onScoreChanged)
	SignalBus.maxScoreSetted.connect(_onMaxScoreSetted)
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
	var colourTween := create_tween()
	var tween := create_tween()
	var originalColor := Color.WHITE
	self.modulate = fireFlash if zone == Types.Zone.Right else waterFlash
	colourTween.tween_property(self, "modulate", originalColor, 1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", _startingPosition - Vector2(4, 0), 0.05)
	tween.tween_property(self, "position", _startingPosition + Vector2(0, 4), 0.05)
	tween.tween_property(self, "position", _startingPosition - Vector2(0, 4), 0.05)
	tween.tween_property(self, "position", _startingPosition + Vector2(4, 0), 0.1)
	tween.tween_property(self, "position", _startingPosition - Vector2(4, 0), 0.1)
	tween.tween_property(self, "position", _startingPosition + Vector2(0, 4), 0.1)
	tween.tween_property(self, "position", _startingPosition - Vector2(0, 4), 0.1)
	tween.tween_property(self, "position", _startingPosition, 0.1)
