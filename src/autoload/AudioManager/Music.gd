class_name Music
extends Resource

@export var id : ResourceIds.MusicId 
@export var stream : AudioStream
@export_range(-40, 20) var volume: float = 0 
@export_range(0.0, 4.0,.01) var pitchScale: float = 1.0 
