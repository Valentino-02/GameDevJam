class_name Game extends Node2D

var _patienceManager := PatienceManager.new()


func _ready() -> void:
	SignalBus.zoneGotCargo.connect(_onZoneGotCargo)
	SignalBus.hazardFixed.connect(_onHazardFix)
	AudioManager.music.play(ResourceIds.MusicId.MainTheme)
	CutsceneManager.sceneLoaded.emit()	


func _onZoneGotCargo(zone: Types.Zone) -> void:
	_patienceManager.gainPatience(zone)

func _on_timer_timeout() -> void:
	_patienceManager.triggerPatienceLoss()
	
func _onHazardFix(hazard: Types.Element) -> void:
	var zone = Types.Zone.Left if hazard == Types.Element.Water else Types.Zone.Right
	_patienceManager.gainPatience(zone)
