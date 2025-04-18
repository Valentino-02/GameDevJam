extends Area2D

@onready var _emitter : GPUParticles2D = get_node("GPUParticles2D")
##TODO: Add rain sound effects here


##Checks if this is an active cloud and starts the emitter
func _onAreaEntered(area : Area2D):
    var parent : Node = area.get_parent()
    if parent is RainCloud and parent.raining:
        _emitter.emitting = true

##Checks if there are no overlapping active rain clouds and turns off the emitter
func _onAreaLeft(area : Area2D):
    for body in get_overlapping_areas():
        var parent : Node = body.get_parent()
        if parent is RainCloud and parent.raining:
            _emitter.emitting = true
            return
    _emitter.emitting = false