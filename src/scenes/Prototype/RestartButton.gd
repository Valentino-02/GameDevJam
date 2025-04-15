extends Button

func _pressed() -> void:
	SignalBus.restart.emit()