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

func _on_test_game_button_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Test)
		_startGame()

func _on_level_1_game_button_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Level1)
		_startGame()


func _on_hazard_tutorial_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial2)
		_startGame()

func _on_movement_tutorial_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial)
		_startGame()
