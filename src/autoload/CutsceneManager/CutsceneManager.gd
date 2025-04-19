extends Node

var dialogueDisplay: DialogueDisplay
var playerCamera: PhantomCamera2D

var currentCutscene: Cutscene
var currentCamera: PhantomCamera2D
var currentStoryPoint: StoryPoint
var cutsceneCameras: Dictionary[StringName, PhantomCamera2D]

@warning_ignore_start("unused_signal")
signal sceneLoaded

func PlayCutscene(cutscene: Cutscene) -> void:
	playerCamera = get_node_or_null("/root/Game/MainCamera")
	dialogueDisplay  = get_node_or_null("/root/Game/UI/CutsceneUI")
	get_tree().paused = true
	dialogueDisplay.Declutter(true)
	currentCutscene = cutscene
	cutsceneCameras = cutscene.useableCameras
	for point in cutscene.storyPoints:
		await _playStoryPoint(point)
	_endCutscene()
	
func _playStoryPoint(storyPoint: StoryPoint) -> void:
	if currentStoryPoint != null:
		currentCamera.priority = 0
	currentStoryPoint = storyPoint
	currentCamera = cutsceneCameras[storyPoint.cameraToUse]
	currentCamera.priority = 20
	await currentCamera.tween_completed
	if storyPoint.childToTrigger != "":
		_activateChild(storyPoint.childToTrigger)
	var dialogueRemaining: int = storyPoint.dialogues.size()
	for dialogue in storyPoint.dialogues:
		dialogueRemaining -= 1
		dialogueDisplay.PlayDialogue(dialogue, dialogueRemaining > 0)
		await dialogueDisplay.dialogueComplete
		
func _endCutscene() -> void:
	currentCamera.priority = 0
	await playerCamera.tween_completed
	currentCamera = null
	currentStoryPoint = null
	cutsceneCameras.clear()
	currentCutscene = null
	dialogueDisplay.Declutter(false)
	get_tree().paused = false

func _activateChild(childName: String) -> void:
	currentCutscene.get_node(childName).Activate()
