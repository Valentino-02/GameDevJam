extends CutsceneBehaviour

@export var tutorialCutsceneManager: Node2D

func Activate() -> void:
	pass

func Finish() -> void:
	tutorialCutsceneManager.completeCutscene()
