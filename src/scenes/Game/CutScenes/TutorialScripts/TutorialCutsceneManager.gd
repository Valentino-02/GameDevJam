extends Node2D

@export var cutscenes: Array[Cutscene] = []
@export var finalCutscene: Cutscene
var cutscenesPlayed: int = 0 

func completeCutscene() -> void:
	cutscenesPlayed += 1
	print("Cutscenes %s / %s"%[cutscenesPlayed, cutscenes.size()])
	if cutscenesPlayed == cutscenes.size():
		TransitionManager.changeToScene(ResourceIds.SceneId.MainMenu)
	elif cutscenesPlayed >= cutscenes.size()-1:
		_playFinalCutscene()
	
func _playFinalCutscene() -> void:
	print("Playing last cutscene")
	finalCutscene.ManualTrigger()
	
