class_name BackgroundZoom extends TextureRect

var _zoomMult: float = 1
var _zoomDuration: float = 1
var _defaultScale: Vector2 = Vector2.ONE


func _zoomBackground() -> void:
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self,"scale",_defaultScale*_zoomMult,_zoomDuration)
	
func ZoomBackground(zoomMultiplier: float, zoomDuration: float) -> void:
	_zoomMult = zoomMultiplier
	_zoomDuration = zoomDuration
	_zoomBackground()