class_name GameUI extends Control

@onready var _minmapUI: MinimapUI = %MinimapUI


func setMinimapTilemaps(tileMaps: Array[TileMapLayer]) -> void:
	_minmapUI.minimap.setTilemaps(tileMaps)

func setMinimapCamera(camera: Camera2D) -> void:
	_minmapUI.minimap.setCamera(camera)

func _on_reset_button_pressed() -> void:
	TransitionManager.changeToScene(ResourceIds.SceneId.Game)
