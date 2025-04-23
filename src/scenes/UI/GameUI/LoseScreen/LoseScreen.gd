class_name LoseScreen extends Control

@onready var _modal : Control = %Modal
@onready var _restartButton : Button = %RestartButton
@onready var _label : Label = %Label

var _hiddenPosition := Vector2(0, -300)
var _targetPosition : Vector2
var _isSecretWin


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().process_frame 
	_targetPosition = _modal.position
	_hiddenPosition.x = _modal.position.x
	SignalBus.zonePatienceEnded


func trigger(isSecretWin: bool = false) -> void:
	if isSecretWin:
		_isSecretWin = isSecretWin
		_restartButton.text = "Next Level"
	AudioManager.sfx.play(ResourceIds.SfxId.LoseFanfare)
	_playIntroAnimation()
	await get_tree().create_timer(4.0).timeout
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

func _onZonePatienceEnded(zone: Types.Zone) -> void:
	_label.text = "The World Exploded in a Sea of Flames" if zone == Types.Zone.Left else "Desolation in the Form of and Endless Tundra"

func _on_restart_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	if _isSecretWin:
		SignalBus.nextLevelClicked.emit()
		return
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)

func _on_main_menu_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	TransitionManager.changeToScene(ResourceIds.SceneId.MainMenu)
