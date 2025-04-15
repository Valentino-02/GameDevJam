class_name ZoneCounterUI extends Control

@export var zone : Types.Zone

@onready var _label = %Label
@onready var _progressBar = %ProgressBar


func _ready() -> void:
	var text = "Left" if zone == Types.Zone.Left else "Right"
	_label.text = str(text, " Zone Patience")
	SignalBus.zonePatienceChanged.connect(_onPatienceValueChanged)

func _onPatienceValueChanged(targetZone: Types.Zone, value: float) -> void:
	if zone != targetZone:
		return
	_progressBar.value = value
