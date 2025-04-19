extends Node2D

@export var _camera : Camera2D

@export var _maxFireballs : int = 2
@export var _maxRainClouds : int = 2
@export var _removalDistance : float = 2500


var _rainCloudScene : PackedScene = preload("res://src/scenes/Game/Components/RainObstacle/RainCloud.tscn")

var _rainCloudsCount : int = 0
var _fireballCount : int = 0

var _instanced : Array[Node2D] = []

func _ready() -> void:
	SignalBus.zonePatienceChanged.connect(_onZonePatienceChanged)
	await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	_followCamera()
	if randi() % 20 == 0: _removeFar()
	if _rainCloudsCount < _maxRainClouds: _spawnRainCloud()
	if _fireballCount < _maxFireballs: _spawnFireball()

func _removeFar():
	for node in _instanced:
		if node is Node2D and node.global_position.distance_to(global_position) > _removalDistance: 
			node.queue_free()

func _followCamera():
	self.global_position = _camera.get_screen_center_position()

func _spawnFireball():
	var view_rect : Rect2 = _camera.get_viewport_rect()
	var center : Vector2 = _camera.get_screen_center_position()
	var to_edge_of_screen : Vector2 =  Vector2(view_rect.size.x * 0.6, view_rect.size.y * randf_range(-0.6,0.6))

	var pos : Vector2 = center + to_edge_of_screen
	var rot : float  = pos.angle_to_point(center) + PI/2 + randf_range(-1, 1)
	#creates and tracks the fireball
	_fireballCount += 1
	var fireball : Node2D = await Launcher.launchFireball(pos, rot, self)
	if fireball:
		_instanced.append(fireball)
		fireball.tree_exiting.connect(func (): 
			_fireballCount -= 1
			_instanced.erase(fireball))
	else:
		_fireballCount -= 1

func _spawnRainCloud():
	var rain_cloud : Node2D = _rainCloudScene.instantiate()
	
	var view_rect : Rect2 = _camera.get_viewport_rect()
	var center : Vector2 = _camera.get_screen_center_position()
	var to_edge_of_screen : Vector2 = + Vector2(view_rect.size.x * randf_range(-1,1), view_rect.size.y * randf_range(-0.2, -0.6))
	
	rain_cloud.global_position = center + 3 * to_edge_of_screen 
	var tween = rain_cloud.create_tween().set_process_mode(Tween.TweenProcessMode.TWEEN_PROCESS_PHYSICS)
	#fly in
	tween.tween_property(rain_cloud,"global_position", center + to_edge_of_screen, randf_range(4,15))
	#wait around
	tween.tween_interval(randf_range(8,15))
	#fly away
	tween.tween_property(rain_cloud,"global_position", center + to_edge_of_screen + (Vector2.UP * 700), randf_range(5,15))
	tween.tween_callback(rain_cloud.queue_free)

	_instanced.append(rain_cloud)
	_rainCloudsCount += 1
	rain_cloud.tree_exiting.connect(func ():
		_rainCloudsCount -= 1
		_instanced.erase(rain_cloud))
	get_parent().add_child(rain_cloud)




func _onZonePatienceChanged(zone: Types.Zone, value: float):
	if zone == Types.Zone.Left:
		if  _maxRainClouds < 20 and randi() % 20 == 0 : _maxRainClouds += 1
	else:
		if _maxFireballs < 20 and randi() % 20 == 0: _maxFireballs += 1
