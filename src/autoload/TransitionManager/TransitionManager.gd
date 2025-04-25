extends CanvasLayer

@export var sceneList: Array[Scene] 

@onready var _colorRect: ColorRect = $ColorRect

var _sceneById: Dictionary[ResourceIds.SceneId, Scene] = {} 
var _transitionTime := 2.0

var _transitioning: bool = false
var Transitioning: bool:
	get:
		return _transitioning


func _ready() -> void:
	for scene in sceneList:
		_sceneById[scene.id] = scene
	_colorRect.modulate.a = 0.0


func changeToScene(id: ResourceIds.SceneId) -> void:
	var scene = _sceneById.get(id) as Scene
	if scene == null:
		push_error("Transition Manager failed to find scene with id ", id)
	_transitioning = true
	await _transitionIn()
	get_tree().change_scene_to_packed(scene.packedScene)
	_transitionOut()
	_transitioning = false

func _transitionIn() -> void:
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_colorRect, "modulate:a", 1.0, _transitionTime / 2.0)
	await tween.finished

func _transitionOut() -> void:
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_colorRect, "modulate:a", 0.0, _transitionTime / 2.0)
