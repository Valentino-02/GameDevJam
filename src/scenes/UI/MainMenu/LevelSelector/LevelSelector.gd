class_name LevelSelector extends Control

var _isTransitioning := false
var _isOpen := false

func changeOpenState() -> void:
	if _isTransitioning:
		return
	if not _isOpen:
		_playIntroAnimation()
		_isOpen = true
		return
	if _isOpen:
		_playOutroAnimation()
		_isOpen = false

func _playIntroAnimation() -> void:
	_isTransitioning = true
	modulate.a = 0.0
	show()
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	_isTransitioning = false

func _playOutroAnimation() -> void:
	_isTransitioning = true
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	hide()
	_isTransitioning = false

func _startGame() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)
	AudioManager.music.stop()


func _on_tutorial_1_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial1)
	_startGame()

func _on_tutorial_2_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial2)
	_startGame()

func _on_tutorial_3_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial3)
	_startGame()

func _on_tutorial_4_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial4)
	_startGame()

func _on_tutorial_5_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial5)
	_startGame()

func _on_tutorial_6_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial6)
	_startGame()

func _on_tutorial_7_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial7)
	_startGame()

func _on_tutorial_8_pressed() -> void:
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial8)
	_startGame()
