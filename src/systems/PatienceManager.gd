class_name PatienceManager

const MAX_PATIENCE = 100.0

var _patienceLossPerSecond = 1.0
var _cargoPatienceGain = 20.0
var _leftPatience : float = MAX_PATIENCE:
	set(newValue):
		_leftPatience = clamp(newValue, 0, MAX_PATIENCE)
		SignalBus.zonePatienceChanged.emit(Types.Zone.Left, _leftPatience)
var _rightPatience : float = MAX_PATIENCE:
	set(newValue):
		_rightPatience = clamp(newValue, 0, MAX_PATIENCE)
		SignalBus.zonePatienceChanged.emit(Types.Zone.Right, _rightPatience)


func setPatienceLoss(value: float) -> void:
	_patienceLossPerSecond = value

func setCargoPatienceGain(value: float) -> void:
	_cargoPatienceGain = value

func triggerPatienceLoss() -> void:
	_leftPatience -= _patienceLossPerSecond
	_rightPatience -= _patienceLossPerSecond

func gainPatience(zone: Types.Zone) -> void:
	if zone == Types.Zone.Left:
		_leftPatience += _cargoPatienceGain
	if zone == Types.Zone.Right:
		_rightPatience += _cargoPatienceGain
