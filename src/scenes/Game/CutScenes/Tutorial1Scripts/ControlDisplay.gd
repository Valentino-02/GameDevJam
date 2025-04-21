extends Node2D

var _fadingOut: bool  = false
var _fadingIn: bool  = false
var _fadeSpeed: float = 3

func DisplayLeft() -> void:
	_fadeIn()
	get_node("Left").show()
	
func DisplayRight() -> void:
	_fadeIn()
	get_node("Right").show()
	
func FadeOut() -> bool:
	_fadingOut = true
	if modulate.a == 0:
		return true
	return false
	
func _fadeIn() -> void:
	modulate.a = 0
	_fadingIn = true
	
func _process(delta: float) -> void:
	if _fadingIn && !_fadingOut:
		var targetColor: Color = modulate
		targetColor.a = 1
		_Fade(targetColor, delta*_fadeSpeed*2)
		if modulate.a == 1:
			_fadingIn = false
	if _fadingOut:
		var targetColor: Color = modulate
		targetColor.a = 0
		_Fade(targetColor, delta*_fadeSpeed)
		
func _Fade(targetColor: Color, speed: float) -> void:
	modulate = lerp(modulate, targetColor, speed)