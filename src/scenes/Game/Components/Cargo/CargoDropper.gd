class_name CargoDropper extends Node2D

@export var cooldown : float = 0.4
@export var cargoScene : PackedScene
@export var element : Types.Element 

@onready var _cooldownTimer : Timer = %CooldownTimer
@onready var _spawnMarker : Marker2D = %SpawnMarker
@onready var _distributionMarker : Marker2D = %DistributionMarker
@onready var _forgeSprites: AnimatedSprite2D = $ForgeBody
@onready var _pipes: AnimatedSprite2D = $ForgeBody/Pipes
@onready var _smoke: Node2D = $ForgeBody/Pipes/Smoke
@onready var _bubbles: Node2D = $ForgeBody/Bubbles
@onready var _dispenser: Node2D = %Dispenser

var _interactable : bool = false
var _onCooldown : bool = false



func _ready() -> void:
	_prepareSprites()
	_cooldownTimer.wait_time = cooldown
	SignalBus.registerForMinimap.emit(self)
	_floatForever(_forgeSprites.position)

func _process(_delta: float) -> void:
	if not _interactable:
		return
	if _onCooldown:
		return
	if Input.is_action_pressed("Interact"):
		_triggerDrop()


func _triggerDrop() -> void:
	_onCooldown = true
	_cooldownTimer.start()
	_animateDrop()
	AudioManager.sfx.play(ResourceIds.SfxId.Click)
	_spawnCargo()

func _spawnCargo() -> void:
	var cargo : Cargo = cargoScene.instantiate()
	cargo.setElement(Types.Element.Fire if element == Types.Element.Fire else Types.Element.Water) 
	cargo.position.y = _spawnMarker.position.y
	var distribution = abs(_distributionMarker.position.x)
	cargo.position.x = _spawnMarker.position.x + randf_range(-distribution, distribution)
	add_child(cargo) ## NOTE Cargo is being added as a child of this scene, which is not ideal.

func _floatForever(startPos: Vector2) -> void:
	var amp := 5.0  
	var dur := 1.0   
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(_forgeSprites, "position", startPos + Vector2(0, -amp), dur)
	tween.tween_property(_forgeSprites, "position", startPos, dur)
	await tween.finished
	_floatForever(startPos)

func _setAsInteractable() -> void:
	_interactable = true
	_pipes.play("drop")
	_smoke.show()
	var tween := create_tween()
	_smoke.modulate.a = 0.0
	tween.tween_property(_smoke, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _setAsUninteractable() -> void:
	var tween := create_tween()
	_smoke.modulate.a = 1.0
	tween.tween_property(_smoke, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	_interactable = false
	await _pipes.animation_looped
	_pipes.stop()

func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body.get_groups().has("PlayerPlatform"):
		_setAsInteractable()

func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	if body.get_groups().has("PlayerPlatform"):
		_setAsUninteractable()

func _on_cooldown_timer_timeout() -> void:
	_onCooldown = false

func _prepareSprites() -> void:
	_forgeSprites.play("fire" if element == Types.Element.Fire else "water")
	if element == Types.Element.Fire:
		_pipes.position.y += 1 
	else:
		_bubbles.show()

func _animateDrop() -> void:
	_dispenser.play("drop")
	await _dispenser.animation_finished
	_dispenser.frame = 0
