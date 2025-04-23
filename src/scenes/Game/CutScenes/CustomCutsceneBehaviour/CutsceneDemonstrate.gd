extends CutsceneBehaviour

@export var hazardsToDemonstrate: Array[Node2D] = []

func Activate() -> void:
	for hazard in hazardsToDemonstrate:
		hazard.process_mode = Node.PROCESS_MODE_ALWAYS
		if hazard is WindObstacle:
			hazard.Activate()
	
	
func Finish() -> void:	
	for hazard in hazardsToDemonstrate:
		hazard.process_mode = Node.PROCESS_MODE_INHERIT
