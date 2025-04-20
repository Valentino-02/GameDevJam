@tool
class_name Launcher extends Node2D

##The projectile to send
@export var rigid_body_projectile_scene : PackedScene
##How long between each projectile before the next is sent, loops
@export var spawn_pattern : Array[float] = [0.5, 0.5, 1, 1, 3]
##A coefficient for the force of each projectile, loops
@export var force_pattern : Array[float] = [0.5, 0.5, 1, 1, 1.2]


@onready var _timer : Timer = get_node("Timer")
var _spawnIdx : int = 0 
var _forceIdx : int = 0 
const FORCE_MULTIPLIER : float = 700


func _get_next(index : int, pattern : Array[float] ) -> float:
	return pattern[index % pattern.size()]

##launches the projectile and restarts the timer
func _onTimerTimeout():
	var force : float = _get_next(_forceIdx, force_pattern) * FORCE_MULTIPLIER
	_launchBody(force)
	_forceIdx += 1 #overflow isn't an issue
	
	_timer.start(_get_next(_spawnIdx, spawn_pattern))
	_spawnIdx += 1 #overflow isn't an issue
	
	
##Spawns the object and sets it in motion
func _launchBody(force : float):
	var body : RigidBody2D = rigid_body_projectile_scene.instantiate()
	self.add_child(body)
	body.global_position = self.global_position
	body.global_rotation = self.global_rotation
	#took me an embarrassingly long time to figure out that this was the problem
	var direction : Vector2 = to_global(Vector2.UP) - global_position
	body.add_constant_force(direction * force)
	body.apply_impulse(direction * force)
	#this is to stop the projectile from accelerating too far
	await get_tree().create_timer(0.3).timeout
	if body: body.constant_force = Vector2.ZERO
	await get_tree().create_timer(5).timeout
	if body: body.queue_free()

##To help us oreintate it in editor only
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, Vector2.UP * 15, Color.RED, 4)
		draw_line(Vector2(-5,-10), Vector2.UP * 15.5, Color.RED, 3)
		draw_line(Vector2(5,-10), Vector2.UP * 15.5, Color.RED, 3)
