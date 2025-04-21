class_name MainMenu
extends CanvasLayer

@onready var _levelSelector : LevelSelector = %LevelSelector


func _ready() -> void:
	AudioManager.music.play(ResourceIds.MusicId.MainMenuTheme)


func _on_start_game_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	LevelManager.setTargetLevel(ResourceIds.LevelId.Tutorial)
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)
	AudioManager.music.stop()

func _on_level_selection_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	_levelSelector.changeOpenState()

func _on_quit_game_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	get_tree().quit()
