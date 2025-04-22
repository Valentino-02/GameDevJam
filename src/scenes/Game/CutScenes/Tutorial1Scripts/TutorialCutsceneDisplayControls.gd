extends CutsceneBehaviour

@export var tutorialCutsceneManager: Node2D
@export var controlsDisplay: PackedScene
@export var displayMaxDuration: float = 10

@onready var _leftPlayer: Node2D = get_parent().get_parent().get_node("../PlayerCharacter/LeftCharacter")
@onready var _rightPlayer: Node2D = get_parent().get_parent().get_node("../PlayerCharacter/RightCharacter")

var _controlsPosition: Array[Node2D]
var _displaying: = false
var _displayTime: float = 0


func Activate() -> void:
	pass
	
func Finish() -> void:
	_displayControls()
	tutorialCutsceneManager.completeCutscene()
	
func _displayControls() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	for type in ["Left","Right"]:
		var controls: Node2D = controlsDisplay.instantiate()
		add_child(controls)
		_controlsPosition.append(controls)
		if type == "Left":
			controls.DisplayLeft()
		else:
			controls.DisplayRight()
	_displaying = true
		
func _process(delta: float) -> void:
	if !_displaying: return
	_controlsPosition[0].global_position = _leftPlayer.global_position
	_controlsPosition[1].global_position = _rightPlayer.global_position
	_displayTime += delta
	
	if _displayTime <= displayMaxDuration: return
	if _fadeOut():
		_stop()
	
func _fadeOut() -> bool:
	var left: bool = _controlsPosition[0].FadeOut() 
	var right: bool = _controlsPosition[1].FadeOut() 
	return left && right
	
func _stop() -> void:
	_displaying = false
	_controlsPosition[0].queue_free()
	_controlsPosition[1].queue_free()
	queue_free()
