extends CutsceneBehaviour

@export var tutorialCutsceneManager: Node2D

func Activate() -> void:
	_displayControls()
	
func Finish() -> void:
	tutorialCutsceneManager.completeCutscene()
	
func _displayControls() -> void:
	pass