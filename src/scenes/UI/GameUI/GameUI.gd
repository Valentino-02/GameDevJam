class_name GameUI extends Control


func _on_reset_button_pressed() -> void:
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)
