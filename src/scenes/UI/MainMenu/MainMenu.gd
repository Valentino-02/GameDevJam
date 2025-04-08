class_name MainMenu
extends CanvasLayer

func _ready() -> void:
	AudioManager.music.play(ResourceIds.MusicId.MainTheme)

func _on_start_game_button_pressed() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)
	AudioManager.music.stop()
