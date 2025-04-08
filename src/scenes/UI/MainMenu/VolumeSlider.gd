class_name VolumeSlider
extends VBoxContainer

@export var title : String
@export var type : AudioType = AudioType.Music

@onready var _slider : HSlider = $HSlider
@onready var _label : Label = $Label

enum AudioType {
	Music,
	Sfx
}


func _ready():
	if type == AudioType.Music: 
		_slider.set_value_no_signal(AudioManager.getMusicVolume())
	elif type == AudioType.Sfx: 
		_slider.set_value_no_signal(AudioManager.getSfxVolume())
	_label.text = title


func _on_h_slider_value_changed(value: float) -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	if type == AudioType.Music:
		AudioManager.setMusicVolume(value)
	elif type == AudioType.Sfx: 
		AudioManager.setSfxVolume(value)
