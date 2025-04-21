extends Control

@onready var _elementalLabel : Label = %ElementalLabel
@onready var _deliveryLabel : Label = %DeliveryLabel

func _ready() -> void:
	_floatForever(_elementalLabel, _elementalLabel.position)
	await get_tree().create_timer(0.3).timeout
	_floatForever(_deliveryLabel, _deliveryLabel.position)

func _floatForever(label: Label, startPos: Vector2) -> void:
	var amp := randf_range(8.0, 10.0)  
	var dur := randf_range(0.9, 1.2)   

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position", startPos + Vector2(0, -amp), dur)
	tween.tween_property(label, "position", startPos, dur)


	await tween.finished
	_floatForever(label, startPos)
