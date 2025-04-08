extends CanvasLayer

@export var sceneList: Array[Scene] 

@onready var _colorRect: ColorRect = $ColorRect

var _sceneById: Dictionary[ResourceIds.SceneId, Scene] = {} 
var _transitionTime := 2.0


func _ready() -> void:
	for scene in sceneList:
		_sceneById[scene.id] = scene
	_colorRect.modulate.a = 0.0


func changeToScene(id: ResourceIds.SceneId) -> void:
	var scene = _sceneById.get(id) as Scene
	if scene == null:
		push_error("Transition Manager failed to find scene with id ", id)
	await _transition_in()
	get_tree().change_scene_to_packed(scene.packedScene)
	_transition_out()

func _transition_in() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(_colorRect, "modulate:a", 1.0, _transitionTime / 2.0)
	await tween.finished

func _transition_out() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(_colorRect, "modulate:a", 0.0, _transitionTime / 2.0)
