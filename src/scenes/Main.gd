# Entry point of the app
extends Node


func _ready() -> void:
	TransitionManager.changeToScene(ResourceIds.SceneId.MainMenu)
