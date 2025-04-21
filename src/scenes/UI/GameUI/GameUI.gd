class_name GameUI extends Control

@onready var _minimapUI : MinimapUI = %MinimapUI
@onready var _pauseMenu : PauseMenu = %PauseMenu


func setMinimapTilemaps(tileMaps: Array[TileMapLayer]) -> void:
	_minimapUI.minimap.setTilemaps(tileMaps)

func setMinimapCamera(camera: Camera2D) -> void:
	_minimapUI.minimap.setCamera(camera)
	
func drawMinimap() -> void:
	_minimapUI.minimap.BeginDraw()


func _on_pause_menu_button_pressed() -> void:
	_pauseMenu.changeOpenState()
