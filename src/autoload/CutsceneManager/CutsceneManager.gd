extends Node

var dialogueDisplay: DialogueDisplay

var currentCutscene: Cutscene
var defaultCamera: Camera2D
var playerCamera: PhantomCamera2D
var currentCamera: PhantomCamera2D
var currentStoryPoint: StoryPoint
var cutsceneCameras: Dictionary[StringName, PhantomCamera2D]
var parallax: ParallaxZoom = null
var background: BackgroundZoom = null

var _cutsceneRunning:bool  = false
var _game: Game

var Running: bool:
	get:
		return _cutsceneRunning

var _quitting: bool = false

@warning_ignore_start("unused_signal")
signal sceneLoaded

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta: float) -> void:
	if _cutsceneRunning:
		if defaultCamera == null:
			defaultCamera = _game.Camera
		_game.updateBackgroundPosition()
		PlayerRelativePosition.relativePosition = (defaultCamera.get_screen_center_position().x - _game.Boundaries.getLeftWallPosition().x)/_game.Boundaries.getLevelWidth()

func PlayCutscene(cutscene: Cutscene) -> void:
	_quitting = false
	if _game == null:
		_game = get_node("/root/Game")
	if parallax == null:
		parallax = get_node("/root/Game/Parallax2DGroup")
	if background == null:
		background = get_node("/root/Game/Background/BackgroundTextureRect")
	playerCamera = get_tree().get_nodes_in_group("MainCamera")[0]
	dialogueDisplay  = get_node_or_null("/root/Game/UI/DialogueUI")
	await get_tree().process_frame
	dialogueDisplay.Declutter(true)
	await get_tree().create_timer(0.5,true).timeout
	_cutsceneRunning = true
	_setProcessMode(cutscene.keepActive, true)
	get_tree().paused = true
	currentCutscene = cutscene
	cutsceneCameras = cutscene.useableCameras
	for point in cutscene.storyPoints:
		if _quitting:
			break
		await _playStoryPoint(point)
	_endCutscene()
	
func QuitCutscene() -> void:
	_quitting = true
	
func _playStoryPoint(storyPoint: StoryPoint) -> void:
	if currentStoryPoint != null:
		currentCamera.priority = 0
	currentStoryPoint = storyPoint
	currentCamera = cutsceneCameras[storyPoint.cameraToUse]
	currentCamera.priority = 20
	_zoom(currentCamera.zoom.x, currentCamera.tween_duration)
	if storyPoint.childToTrigger != "":
		_activateChild(storyPoint.childToTrigger)
	await currentCamera.tween_completed
	var dialogueRemaining: int = storyPoint.dialogues.size()
	if storyPoint.dialogues.size() > 0:
		for dialogue in storyPoint.dialogues:
			if _quitting:
				break
			dialogueRemaining -= 1
			dialogueDisplay.PlayDialogue(dialogue, dialogueRemaining > 0)
			await dialogueDisplay.dialogueComplete
	else:
		await get_tree().create_timer(1,true).timeout
	if storyPoint.childToTrigger != "":
		_finishChild(storyPoint.childToTrigger)
		
func _endCutscene() -> void:
	if currentCamera != null:
		currentCamera.priority = 0
	_zoom(playerCamera.zoom.x, playerCamera.tween_duration)
	await playerCamera.tween_completed
	currentCamera = null
	currentStoryPoint = null
	cutsceneCameras.clear()
	dialogueDisplay.Declutter(false)
	get_tree().paused = false
	if currentCutscene != null:
		_setProcessMode(currentCutscene.keepActive)
	currentCutscene = null
	_cutsceneRunning = false
	defaultCamera = null

func _activateChild(childName: String) -> void:
	currentCutscene.get_node(childName).Activate()

func _finishChild(childName: String) -> void:
	currentCutscene.get_node(childName).Finish()

func _zoom(zoomAmount: float, duration: float) -> void:
	parallax.ZoomParallax(zoomAmount, duration)
	background.ZoomBackground(zoomAmount, duration)

func _setProcessMode(nodes: Array[Node2D], active:bool = false) -> void:
	for node in nodes:
		node.process_mode = Node.PROCESS_MODE_ALWAYS if active else Node.PROCESS_MODE_INHERIT
