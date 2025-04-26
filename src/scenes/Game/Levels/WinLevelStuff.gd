extends Node


func _ready() -> void:
	AudioManager.music.play(ResourceIds.MusicId.WinTheme)
