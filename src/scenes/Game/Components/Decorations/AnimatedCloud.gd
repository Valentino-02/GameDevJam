extends Sprite2D

var _startPos : Vector2

func _ready() -> void:
	_startPos = position
	_floatForever()


func _floatForever() -> void:
	var amp := randf_range(2.0, 5.0)  
	var dur := randf_range(1.5, 2.0)   
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", _startPos + Vector2(0, -amp), dur)
	tween.tween_property(self, "position", _startPos, dur)
	await tween.finished
	_floatForever()
