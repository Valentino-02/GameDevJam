class_name FleetingNumber extends Node2D

@onready var _sprite : Sprite2D = $Sprite2D

func _ready():
	var tween := create_tween()
	tween.set_parallel(true)
	scale = Vector2(0.6, 0.6)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + Vector2(0, -40), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	modulate.a = 1.0
	tween.tween_property(self, "modulate:a", 0.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
