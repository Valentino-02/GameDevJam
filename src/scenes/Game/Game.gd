class_name Game extends Node2D

var _patienceManager := PatienceManager.new()


func _ready() -> void:
	SignalBus.zoneGotCargo.connect(_onZoneGotCargo)
	AudioManager.music.play(ResourceIds.MusicId.MainTheme)


func _onZoneGotCargo(zone: Types.Zone) -> void:
	_patienceManager.gainPatience(zone)

func _on_timer_timeout() -> void:
	_patienceManager.triggerPatienceLoss()
