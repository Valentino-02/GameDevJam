extends Label

func _ready() -> void:
	SignalBus.restart.connect(hide)
	SignalBus.game_over.connect(show)