extends Area2D

@onready var _emitter : GPUParticles2D = get_node("GPUParticles2D")
@onready var _audioPlayer : AudioStreamPlayer2D =AudioManager.sfx.createPlayer2D(ResourceIds.SfxId.Splashing)

func _ready() -> void:
	add_child(_audioPlayer)
	_audioPlayer.position = Vector2.ZERO



var _clouds : Array[RainCloud] = []

##Checks if this is an active cloud and starts the emitter
func _onAreaEntered(area : Area2D):
	var parent : Node = area.get_parent()
	if parent is RainCloud:
		if not _clouds.has(parent):
			_clouds.append(parent)
			parent.rainingChanged.connect(updateParticles)
	updateParticles()

##Checks if there are no overlapping active rain clouds and turns off the emitter
func _onAreaLeft(_area : Area2D):
	var parent : Node = _area.get_parent()
	if parent is RainCloud:
		if _clouds.has(parent):
			_clouds.erase(parent)
			parent.rainingChanged.disconnect(updateParticles)
	updateParticles()



func updateParticles():
	for rainCloud in _clouds:
		if rainCloud._raining:
			_emitter.emitting = true
			_audioPlayer.play(0.0)
			return
	_emitter.emitting = false
	_audioPlayer.stop()
