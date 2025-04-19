class_name MusicManager
extends Node

@export var musicList: Array[Music]

@onready var _player : AudioStreamPlayer = $AudioStreamPlayer
@onready var _player2 : AudioStreamPlayer = $AudioStreamPlayer2

var _musicById: Dictionary[ResourceIds.MusicId , Music] = {} 
var _activePlayer: AudioStreamPlayer
var _inactivePlayer: AudioStreamPlayer


func _ready() -> void:
	_player.set_bus('Music')
	_player2.set_bus("Music")
	_activePlayer = _player
	_inactivePlayer = _player2
	for music in musicList:
		_musicById[music.id] = music


func play(id : ResourceIds.MusicId, fadeInDuration := 1.5, fromTime := 0.0, activePlayer := true) -> void:
	var targetPlayer = _activePlayer if activePlayer else _inactivePlayer
	var music : Music = _musicById.get(id) as Music
	if music == null:
		push_error("Music Manager failed to find sfx with id ", id)
		return
	targetPlayer.set_stream(music.stream)
	targetPlayer.volume_db = music.volume
	targetPlayer.pitch_scale = music.pitchScale
	targetPlayer.play(fromTime)
	fadeIn(fadeInDuration, activePlayer, music.volume)

func stop(fadeOutDuration := 1.5, activePlayer := true) -> void:
	var targetPlayer = _activePlayer if activePlayer else _inactivePlayer
	var tween = fadeOut(fadeOutDuration, activePlayer)
	await tween.finished

func fadeIn(duration := 1.5, activePlayer := true, targetVolume := 0.0) -> void:
	var targetPlayer = _activePlayer if activePlayer else _inactivePlayer
	targetPlayer.volume_db = Settings.MIN_VOLUME
	var tween = get_tree().create_tween()
	tween.tween_property(targetPlayer, "volume_db", targetVolume, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func fadeOut(duration := 1.5, activePlayer := true) -> Tween:
	var targetPlayer = _activePlayer if activePlayer else _inactivePlayer
	var tween = get_tree().create_tween()
	tween.tween_property(targetPlayer, "volume_db", Settings.MIN_VOLUME, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	return tween

func enableLowPass(duration := 0.5) -> void:
	var tween = get_tree().create_tween()
	var effect = AudioServer.get_bus_effect(AudioManager.getMusicBusIndex(), 0)
	tween.tween_property(effect, "cutoff_hz", Settings.LOW_PASS_HZ_VALUE, duration).set_trans(Tween.TRANS_LINEAR)

func disableLowPass(duration := 0.5) -> void:
	var tween = get_tree().create_tween()
	var effect = AudioServer.get_bus_effect(AudioManager.getSfxBusIndex(), 0)
	tween.tween_property(effect, "cutoff_hz", Settings.NORMAL_HZ_VALUE, duration).set_trans(Tween.TRANS_LINEAR)

func crossFadeTo(id: ResourceIds.MusicId, duration := 1.5) -> void:
	var currentTime := _activePlayer.get_playback_position()
	var now = Time.get_datetime_dict_from_system()
	play(id, duration, currentTime, false)
	now = Time.get_datetime_dict_from_system()
	await stop(duration)
	now = Time.get_datetime_dict_from_system()
	var temp = _activePlayer
	_activePlayer = _inactivePlayer
	_inactivePlayer = temp
