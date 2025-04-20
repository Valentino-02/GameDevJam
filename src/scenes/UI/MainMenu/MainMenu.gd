class_name MainMenu
extends CanvasLayer


func _ready() -> void:
	AudioManager.music.play(ResourceIds.MusicId.MainMenuTheme)


func _startGame() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)
	AudioManager.music.stop()


func _on_tutorial_game_button_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial)
		_startGame()

func _on_test_game_button_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Test)
		_startGame()

func _on_level_1_game_button_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Level1)
		_startGame()


func _on_hazard_tutorial_pressed() -> void:
		LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial2)
		_startGame()
