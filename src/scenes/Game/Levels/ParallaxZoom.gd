class_name ParallaxZoom extends Node2D

@onready var mountain: Parallax2D = get_node("MountainParallax2D")
@onready var cloud: Parallax2D = get_node("CloudParallax2D")
@onready var forest: Parallax2D = get_node("ForestParallax2D")

@onready var _mountainDefault: float = mountain.scroll_scale.x
@onready var _cloudDefault: float = cloud.scroll_scale.x
@onready var _forestDefault: float = forest.scroll_scale.x

var _zoomMult: float = 1
var _zooming: bool = false
var _zoomDuration: float = 1

func _zoomParallax(delta: float) -> bool:
	mountain.scroll_scale.x = lerp(mountain.scroll_scale.x, _mountainDefault * _zoomMult, delta/_zoomDuration)
	cloud.scroll_scale.x = lerp(cloud.scroll_scale.x, _cloudDefault * _zoomMult, delta/_zoomDuration)
	forest.scroll_scale.x = lerp(forest.scroll_scale.x, _forestDefault * _zoomMult, delta/_zoomDuration)
	if mountain.scroll_scale.x == _mountainDefault*_zoomMult && cloud.scroll_scale.x == _cloudDefault*_zoomMult && forest.scroll_scale.x == _forestDefault*_zoomMult:
		return true
	return false
	
func _process(delta: float) -> void:
	if _zooming:
		if _zoomParallax(delta):
			_zooming = false
			
func ZoomParallax(zoomMultiplier: float, zoomDuration: float) -> void:
	_zoomMult = zoomMultiplier
	_zoomDuration = zoomDuration
	_zooming = true