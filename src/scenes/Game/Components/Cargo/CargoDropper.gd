class_name CargoDropper extends Node2D

@export var cooldownTicks : int = 8
@export var tickDuration : float = 0.1
@export var cargoScene : PackedScene
@export var element : Types.Element 

@onready var _cooldownTimer : Timer = %CooldownTimer
@onready var _progressBar : ProgressBar = %ProgressBar
@onready var _uiHelpers : Control = %UI_Helpers
@onready var _spawnMarker : Marker2D = %SpawnMarker
@onready var _distributionMarker : Marker2D = %DistributionMarker
@onready var _temporaryIcon : Sprite2D = %TemporaryIcon

var _interactable : bool = false
var _onCooldown : bool = false
var _currentTick : int = 0 :
	set(newValue):
		_currentTick = clamp(newValue, 0, cooldownTicks)
		_progressBar.value = float(_currentTick)


func _ready() -> void:
	_temporaryIcon.texture = PreloadedResources.fireCrateTexture if element == Types.Element.Fire else PreloadedResources.waterCrateTexture 
	_cooldownTimer.wait_time = tickDuration
	_progressBar.max_value = cooldownTicks
	_progressBar.value = cooldownTicks

func _process(delta: float) -> void:
	if not _interactable:
		return
	if _onCooldown:
		return
	if Input.is_action_pressed("Interact"):
		_triggerDrop()


func _triggerDrop() -> void:
	_onCooldown = true
	_cooldownTimer.start()
	_currentTick = 0
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	_spawnCargo()

func _spawnCargo() -> void:
	var cargo : Cargo = cargoScene.instantiate()
	cargo.setElement(Types.Element.Fire if element == Types.Element.Fire else Types.Element.Water) 
	cargo.position.y = _spawnMarker.position.y
	var distribution = abs(_distributionMarker.position.x)
	cargo.position.x = _spawnMarker.position.x + randf_range(-distribution, distribution)
	add_child(cargo) ## NOTE Cargo is being added as a child of this scene, which is not ideal.

func _onCooldownRecovery() -> void:
	_onCooldown = false

func _setAsInteractable() -> void:
	_interactable = true
	_uiHelpers.show()

func _setAsUninteractable() -> void:
	_interactable = false
	_uiHelpers.hide()

func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body.get_groups().has("PlayerPlatform"):
		_setAsInteractable()

func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	if body.get_groups().has("PlayerPlatform"):
		_setAsUninteractable()

func _on_cooldown_timer_timeout() -> void:
	_currentTick += 1
	if _currentTick == cooldownTicks:
		_cooldownTimer.stop()
		_onCooldownRecovery()
