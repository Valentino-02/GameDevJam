class_name ParallaxZoom extends Node2D

@onready var mountain: Parallax2D = get_node("MountainParallax2D")
@onready var cloud: Parallax2D = get_node("CloudParallax2D")
@onready var forest: Parallax2D = get_node("ForestParallax2D")

@onready var _mountainDefault: float = mountain.scroll_scale.x
@onready var _cloudDefault: float = cloud.scroll_scale.x
@onready var _forestDefault: float = forest.scroll_scale.x

var _zoomMult: float = 1
var _zoomDuration: float = 1

func _zoomParallax() -> void:
	_setTween(mountain, _mountainDefault)
	_setTween(cloud, _cloudDefault)
	_setTween(forest, _forestDefault)
			
func ZoomParallax(zoomMultiplier: float, zoomDuration: float) -> void:
	_zoomMult = zoomMultiplier
	_zoomDuration = zoomDuration
	_zoomParallax()
	
func _setTween(obj: Parallax2D, target: float) -> void:
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(obj,"scroll_scale",Vector2(target*_zoomMult,obj.scroll_scale.y),_zoomDuration)