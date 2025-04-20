class_name SfxManager
extends Node2D

@export var sfxList: Array[Sfx] 

var _sfxById: Dictionary[ResourceIds.SfxId , Sfx] = {} 


func _ready() -> void:
	for sfx in sfxList:
		_sfxById[sfx.id] = sfx


func playAtPosition(id: ResourceIds.SfxId, pos: Vector2):
	var sfx : Sfx = _sfxById.get(id) as Sfx
	if sfx == null:
		push_error("Sfx Manager failed to find sfx with id ", id)
	if not sfx.shouldPlay() :
		return null
	
	var player2D := createPlayer2D(id)
	player2D.global_position = pos
	sfx.addCount()
	player2D.finished.connect(sfx._onAudioFinished)
	player2D.finished.connect(player2D.queue_free)
	add_child(player2D)
	player2D.play()

func createPlayer2D(id: ResourceIds.SfxId) -> AudioStreamPlayer2D:
	var sfx : Sfx = _sfxById.get(id) as Sfx
	if sfx == null:
		push_error("Sfx Manager failed to find sfx with id ", id)
	if not sfx.shouldPlay() :
		return null
	
	var player2D := AudioStreamPlayer2D.new()
	player2D.set_bus('Sfx')
	player2D.stream = sfx.stream
	player2D.volume_db = sfx.volume
	player2D.pitch_scale = sfx.pitchScale
	player2D.attenuation = 2.0
	return player2D

func play(id: ResourceIds.SfxId) -> void:
	var sfx : Sfx = _sfxById.get(id) as Sfx
	if sfx == null:
		push_error("Sfx Manager failed to find sfx with id ", id)
	if not sfx.shouldPlay() :
		return
	
	sfx.addCount()
	var player := AudioStreamPlayer.new()
	player.set_bus('Sfx')
	player.stream = sfx.stream
	player.volume_db = sfx.volume
	player.pitch_scale = sfx.pitchScale
	player.finished.connect(sfx._onAudioFinished)
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
