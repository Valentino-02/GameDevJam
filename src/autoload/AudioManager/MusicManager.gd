class_name MusicManager
extends Node

@export var musicList: Array[Music]

@onready var _player : AudioStreamPlayer = $AudioStreamPlayer

var _musicById: Dictionary[ResourceIds.MusicId , Music] = {} 


func _ready() -> void:
	_player.set_bus('Music')
	for music in musicList:
		_musicById[music.id] = music


func play(id : ResourceIds.MusicId, applyFadeIn := true ) -> void:
	var music : Music = _musicById.get(id) as Music
	if music == null:
		push_error("Sfx Manager failed to find sfx with id ", id)
	_player.set_stream(music.stream)
	_player.volume_db = music.volume
	_player.pitch_scale = music.pitchScale
	_player.play()
	if applyFadeIn:
		fadeIn()

func stop(applyFadeOut := true) -> void:
	if applyFadeOut:
		var tween = fadeOut()
		await tween.finished
	else:
		_player.stop()

func fadeIn(duration := 1.5) -> void:
	var targetVolume = _player.volume_db
	_player.volume_db = Settings.MIN_VOLUME
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_player, "volume_db", targetVolume, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func fadeOut(duration := 1.5) -> Tween:
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_player, "volume_db", Settings.MIN_VOLUME, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	return tween

func enableLowPass(duration := 0.5) -> void:
	var tween = get_tree().create_tween()
	var effect = AudioServer.get_bus_effect(AudioManager.getMusicBusIndex(), 0)
	tween.tween_property(effect, "cutoff_hz", Settings.LOW_PASS_HZ_VALUE, duration).set_trans(Tween.TRANS_LINEAR)

func disableLowPass(duration := 0.5) -> void:
	var tween = get_tree().create_tween()
	var effect = AudioServer.get_bus_effect(AudioManager.getSfxBusIndex(), 0)
	tween.tween_property(effect, "cutoff_hz", Settings.NORMAL_HZ_VALUE, duration).set_trans(Tween.TRANS_LINEAR)
