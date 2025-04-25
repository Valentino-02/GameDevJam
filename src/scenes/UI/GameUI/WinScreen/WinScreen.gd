class_name WinScreen extends Control

@onready var _modal : Control = %Modal

var _hiddenPosition := Vector2(0, -300)
var _targetPosition : Vector2


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().process_frame 
	_targetPosition = _modal.position
	_hiddenPosition.x = _modal.position.x


func trigger() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.WinFanfare)
	_playIntroAnimation()
	await get_tree().create_timer(2.0).timeout
	AudioManager.music.play(ResourceIds.MusicId.WaitTheme)


func _playIntroAnimation() -> Tween:
	_modal.position = _hiddenPosition
	show()
	var tween := create_tween()
	tween.tween_property(_modal, "position", _targetPosition + Vector2(0, 10), 0.8) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_modal, "position", _targetPosition, 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	return tween


func _on_main_menu_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	TransitionManager.changeToScene(ResourceIds.SceneId.MainMenu)

func _on_next_level_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	SignalBus.nextLevelClicked.emit()
