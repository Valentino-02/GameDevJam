class_name ZoneCounterUI extends VBoxContainer

enum Threshold {Good, Normal, Bad, Terrible}

@export var zone : Types.Zone

@onready var _titleLabel : Label = %TitleLabel
@onready var _statusLabel : Label = %StatusLabel
@onready var _icon : TextureRect = %Icon
@onready var _container : HBoxContainer = %StatusBoxContainer
@onready var _bar : ProgressBar = %ProgressBar

var _startingPosition : Vector2
var _threshold : Threshold = Threshold.Good:
	set(newValue):
		if newValue != _threshold:
			_onThresholdChanged(_threshold, newValue)
		_threshold = newValue


func _ready() -> void:
	_titleLabel.text = "Fire Realm Overheat Level" if zone == Types.Zone.Left else "Water Realm Freeze Level"
	_bar.modulate = Color("6e120c") if zone == Types.Zone.Left else Color("051183")
	_icon.texture = PreloadedResources.fireStability1Texture if zone == Types.Zone.Left else PreloadedResources.waterStability1Texture
	_statusLabel.text = "Sunny!" if zone == Types.Zone.Left else "Chill!"
	if zone == Types.Zone.Right :
		_container.layout_direction = Control.LAYOUT_DIRECTION_RTL
	SignalBus.zonePatienceChanged.connect(_onPatienceValueChanged)
	SignalBus.zoneScoreChanged.connect(_onScoreChanged)
	SignalBus.zonePatienceEnded.connect(_onZonePatienceEnded)
	await get_tree().process_frame 
	_startingPosition = position

func _onThresholdChanged(oldValue : Threshold, newValue : Threshold) -> void:
	if newValue < oldValue:
		return
	var tween = create_tween()
	AudioManager.sfx.play(ResourceIds.SfxId.Clack)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _onScoreChanged(targetZone: Types.Zone, _value: float) -> void:
	if zone != targetZone:
		return
	_bar.modulate = Color("051183") if zone == Types.Zone.Left else Color("6e120c")
	var tween := create_tween()
	tween.tween_property(self, "position", _startingPosition - Vector2(2, 0), 0.05)
	tween.tween_property(self, "position", _startingPosition + Vector2(0, 2), 0.05)
	tween.tween_property(self, "position", _startingPosition - Vector2(0, 2), 0.05)
	tween.tween_property(self, "position", _startingPosition + Vector2(2, 0), 0.05)
	tween.tween_property(self, "position", _startingPosition, 0.1)
	tween.tween_property(_bar, "modulate", Color("6e120c") if zone == Types.Zone.Left else Color("051183"), 1.5)

func _onZonePatienceEnded(_targetZone : Types.Zone) -> void:
	var tween = create_tween()
	AudioManager.sfx.play(ResourceIds.SfxId.Clack)
	if _targetZone != zone:
		tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _onPatienceValueChanged(targetZone: Types.Zone, value: float) -> void:
	if zone != targetZone:
		return
	_bar.value = 100.0 - value
	if zone == Types.Zone.Left:
		if value >= 75.0:
			_threshold = Threshold.Good
			_icon.texture = PreloadedResources.fireStability1Texture
			_statusLabel.text = "Sunny!"
		if value < 75.0 and value >= 50.0:
			_threshold = Threshold.Normal
			_icon.texture = PreloadedResources.fireStability2Texture
			_statusLabel.text = "Hot!"
		if value < 50.0 and value >= 25.0:
			_threshold = Threshold.Bad
			_icon.texture = PreloadedResources.fireStability3Texture
			_statusLabel.text = "Burning..."
		if value < 25.0:
			_threshold = Threshold.Terrible
			_icon.texture = PreloadedResources.fireStability4Texture
			_statusLabel.text = "Hell on Earth"
	if zone == Types.Zone.Right:
		if value >= 75.0:
			_threshold = Threshold.Good
			_icon.texture = PreloadedResources.waterStability1Texture
			_statusLabel.text = "Chill!"
		if value < 75.0 and value >= 50.0:
			_threshold = Threshold.Normal
			_icon.texture = PreloadedResources.waterStability2Texture
			_statusLabel.text = "Cool!"
		if value < 50.0 and value >= 25.0:
			_threshold = Threshold.Bad
			_icon.texture = PreloadedResources.waterStability3Texture
			_statusLabel.text = "Freezing..."
		if value < 25.0:
			_threshold = Threshold.Terrible
			_icon.texture = PreloadedResources.waterStability4Texture
			_statusLabel.text = "Ice Age"
