class_name PauseMenu extends Control

@onready var _modal : Control = %Modal
@onready var _darkBackground : ColorRect = %DarkBackground

var _hiddenPosition := Vector2(0, -300)
var _targetPosition : Vector2
var _isOpen : bool = false
var _isTransitioning : bool = false
var _wasCalled : bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await self.ready 
	await get_tree().process_frame 
	_targetPosition = _modal.position
	_hiddenPosition.x = _modal.position.x

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") :
		changeOpenState()


func changeOpenState() -> void:
	if _wasCalled:
		return
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	_wasCalled = true
	if _isTransitioning:
		await _waitForTransitionEnd()
	_wasCalled = false
	if not _isOpen:
		AudioManager.music.enableLowPass()
		_playIntroAnimation()
		_isOpen = true
		get_tree().paused = true
		return
	if _isOpen:
		AudioManager.music.disableLowPass()
		_playOutroAnimation()
		_isOpen = false
		get_tree().paused = false


func _playIntroAnimation() -> void:
	_isTransitioning = true
	_modal.position = _hiddenPosition
	_darkBackground.modulate.a = 0.0
	show()
	var tween := create_tween()
	var backgroundTween := create_tween()
	backgroundTween.tween_property(_darkBackground, "modulate:a", 0.9, 0.3) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_modal, "position", _targetPosition + Vector2(0, 10), 0.8) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_modal, "position", _targetPosition, 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	_isTransitioning = false

func _playOutroAnimation() -> void:
	_isTransitioning = true
	var tween := create_tween()
	var backgroundTween := create_tween()
	backgroundTween.tween_property(_darkBackground, "modulate:a", 0.0, 0.3) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_modal, "position", _hiddenPosition, 0.3) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	hide()
	_isTransitioning = false

func _waitForTransitionEnd() -> void:
	while _isTransitioning:
		await get_tree().process_frame


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	AudioManager.music.disableLowPass()
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	AudioManager.music.disableLowPass()
	TransitionManager.changeToScene(ResourceIds.SceneId.MainMenu)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if not _modal.get_global_rect().has_point(event.global_position):
			changeOpenState()
