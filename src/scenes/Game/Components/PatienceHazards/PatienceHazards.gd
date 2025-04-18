extends Node2D

@export var camera : Camera2D

var _fireballScene : PackedScene = preload("res://src/scenes/Game/Components/Fireball/Launcher.tscn")
var _rainCloudScene : PackedScene = preload("res://src/scenes/Game/Components/RainObstacle/RainCloud.tscn")

var _rainClouds : Array[Node]
var _launchers : Array[Node]



func _ready() -> void:
	SignalBus.zonePatienceChanged.connect(_onZonePatienceChanged)
	await get_tree().physics_frame
	#_setupHazards()

func _physics_process(delta: float) -> void:
	_followCamera(delta)

func _followCamera(delta : float):
	self.global_position.lerp(camera.get_screen_center_position(), delta * 2)

func _spawnFireball():
	var fireball : Node2D = _fireballScene.instantiate()
	var view_rect : Rect2 = camera.get_viewport_rect()
	var center : Vector2 = camera.get_screen_center_position()
	var to_edge_of_screen : Vector2 = + Vector2(view_rect.size.x * 0.6, view_rect.size.y * randf_range(-0.6,0.6))
	fireball.global_position = center + to_edge_of_screen
	fireball.look_at(center)
	fireball.rotation += PI/2

	_launchers.append(fireball)
	add_child(fireball)

func _spawnRainCloud():
	var rain_cloud = _rainCloudScene.instantiate()
	
	var view_rect : Rect2 = camera.get_viewport_rect()
	var center : Vector2 = camera.get_screen_center_position()
	var to_edge_of_screen : Vector2 = + Vector2(view_rect.size.x * randf_range(-1,1), view_rect.size.y * randf_range(-0.2, -0.6))
	
	rain_cloud.global_position = center + 3 * to_edge_of_screen 
	rain_cloud.create_tween().set_process_mode(Tween.TweenProcessMode.TWEEN_PROCESS_PHYSICS
		).tween_property(rain_cloud,"global_position", center + to_edge_of_screen, randf_range(4,15))

	_rainClouds.append(rain_cloud)
	get_parent().add_child(rain_cloud)




func _onZonePatienceChanged(zone: Types.Zone, value: float):
	if zone == Types.Zone.Left:
		if randi() % 3 == 0: _spawnRainCloud()
	else:
		if randi() % 3 == 0: _spawnFireball()
