extends CutsceneBehaviour

@export var hazardsToDemonstrate: Array[Node2D] = []

func Activate() -> void:
	for hazard in hazardsToDemonstrate:
		hazard.process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func Finish() -> void:	
	for hazard in hazardsToDemonstrate:
		hazard.process_mode = Node.PROCESS_MODE_INHERIT
