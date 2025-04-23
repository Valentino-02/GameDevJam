class_name GameUI extends Control

@onready var _minimapUI : MinimapUI = %MinimapUI
@onready var _pauseMenu : PauseMenu = %PauseMenu
@onready var _loseScreen : LoseScreen = %LoseScreen
@onready var _winScreen : WinScreen = %WinScreen

func setMinimapTilemaps(tileMaps: Array[TileMapLayer]) -> void:
	_minimapUI.minimap.setTilemaps(tileMaps)

func setMinimapCamera(camera: Camera2D) -> void:
	_minimapUI.minimap.setCamera(camera)
	
func drawMinimap() -> void:
	_minimapUI.minimap.BeginDraw()

func openLoseScreen(isSecretWin: bool = false) -> void:
	_loseScreen.trigger(isSecretWin)

func openWinScreen() -> void:
	_winScreen.trigger()

func _on_pause_menu_button_pressed() -> void:
	_pauseMenu.changeOpenState()
	
func setMinimapTargets(nodes: Array[Node2D]) -> void:
	_minimapUI.minimap.SetTargets(nodes)
