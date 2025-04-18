class_name ScoreManager

var _maxScore : float = 15.0

var _leftScore : float = 0:
	set(newValue):
		_leftScore = clamp(newValue, 0, _maxScore)
		SignalBus.zoneScoreChanged.emit(Types.Zone.Left, _leftScore)
		if _leftScore == _maxScore:
			SignalBus.zoneScoreMaxed.emit(Types.Zone.Left)
var _rightScore : float = 0:
	set(newValue):
		_rightScore = clamp(newValue, 0, _maxScore)
		SignalBus.zoneScoreChanged.emit(Types.Zone.Right, _rightScore)
		if _rightScore == _maxScore:
			SignalBus.zoneScoreMaxed.emit(Types.Zone.Right)


func setMaxScore(value: float) -> void:
	_maxScore = value
	SignalBus.maxScoreSetted.emit(_maxScore)

func incrementScore(zone: Types.Zone) -> void:
	if zone == Types.Zone.Left:
		_leftScore += 1
	if zone == Types.Zone.Right:
		_rightScore += 1
