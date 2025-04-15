class_name PatienceManager

const MAX_PATIENCE = 100.0
const PATIENCE_LOSS_PER_SECOND = 1.0
const CARGO_PATIENCE_GAIN = 20.0

var _leftPatience : float = MAX_PATIENCE:
	set(newValue):
		_leftPatience = clamp(newValue, 0, MAX_PATIENCE)
		SignalBus.zonePatienceChanged.emit(Types.Zone.Left, _leftPatience)
var _rightPatience : float = MAX_PATIENCE:
	set(newValue):
		_rightPatience = clamp(newValue, 0, MAX_PATIENCE)
		SignalBus.zonePatienceChanged.emit(Types.Zone.Right, _rightPatience)


func triggerPatienceLoss() -> void:
	_leftPatience -= 1.0
	_rightPatience -= 1.0

func gainPatience(zone: Types.Zone) -> void:
	if zone == Types.Zone.Left:
		_leftPatience += CARGO_PATIENCE_GAIN
	if zone == Types.Zone.Right:
		_rightPatience += CARGO_PATIENCE_GAIN
