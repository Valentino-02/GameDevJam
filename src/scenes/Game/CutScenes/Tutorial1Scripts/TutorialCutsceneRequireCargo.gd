extends CutsceneBehaviour

@export_flags_2d_physics var cargoLayer
@export var tutorialCutsceneManager: Node2D
@export var requiredElement: Types.Element
@export var requiredForTutorial: int = 5

@onready var area: Area2D = get_node("Area2D")

var _emitted = false
var _collected = 0

func Activate() -> void:
	area.collision_mask = cargoLayer
	area.body_entered.connect(_taskComplete)
	
func _taskComplete(node2d: Node2D) -> void:
	var cargo: Cargo = node2d as Cargo
	if cargo.getElement() == requiredElement:
		_collected += 1
		if _collected >= requiredForTutorial:
			_emitted = true
			area.body_entered.disconnect(_taskComplete)
			tutorialCutsceneManager.completeCutscene()
