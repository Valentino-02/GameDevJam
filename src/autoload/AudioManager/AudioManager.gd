extends Node

@onready var music : MusicManager = %MusicManager
@onready var sfx : SfxManager = %SfxManager

var _musicBusIndex : int = -1
var _sfxBusIndex : int = -1


func _ready():
	_musicBusIndex = AudioServer.get_bus_index("Music")
	_sfxBusIndex = AudioServer.get_bus_index("Sfx")
	if _musicBusIndex == -1 or _sfxBusIndex == -1:
		push_error("Audio Manager is missing an audio bus")
	setMusicVolume(Settings.DEFAULT_MUSIC_VOLUME)
	setSfxVolume(Settings.DEFAULT_SFX_VOLUME)


func setMusicVolume(value: float) -> void:
	AudioServer.set_bus_volume_db(_musicBusIndex, linear_to_db(value))
	
func setSfxVolume(value: float) -> void:
	AudioServer.set_bus_volume_db(_sfxBusIndex, linear_to_db(value))

func getMusicVolume():
	return db_to_linear(AudioServer.get_bus_volume_db(_musicBusIndex))
	
func getSfxVolume():
	return db_to_linear(AudioServer.get_bus_volume_db(_sfxBusIndex))

func getMusicBusIndex() -> int:
	return _musicBusIndex

func getSfxBusIndex() -> int:
	return _sfxBusIndex
