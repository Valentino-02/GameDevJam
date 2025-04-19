@tool
class_name Launcher extends Node2D


##How long between each projectile before the next is sent, loops
@export var spawn_pattern : Array[float] = [0.5, 0.5, 1, 1, 3]
##A coefficient for the force of each projectile, loops
@export var force_pattern : Array[float] = [0.5, 0.5, 1, 1, 1.2]


@onready var _timer : Timer = get_node("Timer")
var _spawnIdx : int = 0 
var _forceIdx : int = 0 
const FORCE_MULTIPLIER : float = 500
##The projectile to send
const _fireball : PackedScene = preload("res://src/scenes/Game/Components/Fireball/Fireball.tscn")
##If null will use a fireball, must be a rigidbody
@export var projectile : PackedScene

func _get_next(index : int, pattern : Array[float] ) -> float:
	return pattern[index % pattern.size()]

##launches the projectile and restarts the timer
func _onTimerTimeout():
	var force : float = _get_next(_forceIdx, force_pattern) * FORCE_MULTIPLIER
	if projectile: launchFireball(global_position, global_rotation, self, force, projectile)
	else: launchFireball(global_position, global_rotation, self, force)
	_forceIdx += 1 #overflow isn't an issue
	
	_timer.start(_get_next(_spawnIdx, spawn_pattern))
	_spawnIdx += 1 #overflow isn't an issue
	
##Spawns the object and sets it in motion
static func launchFireball(pos : Vector2, rot : float, parent : Node,force : float = FORCE_MULTIPLIER,  scene : PackedScene = _fireball) -> RigidBody2D:
	var body : RigidBody2D = scene.instantiate()
	parent.add_child(body)
	body.global_position = pos
	body.global_rotation = rot
	#took me an embarrassingly long time to figure out that this was the problem
	var direction : Vector2 = body.to_global(Vector2.UP) - body.global_position
	body.add_constant_force(direction * force)
	body.apply_impulse(direction * force)
	#this is to stop the projectile from accelerating too far
	await parent.get_tree().create_timer(0.3).timeout
	if body: 
		body.constant_force = Vector2.ZERO
		return body
	else: return null


##To help us oreintate it in editor only
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, Vector2.UP * 15, Color.RED, 4)
		draw_line(Vector2(-5,-10), Vector2.UP * 15.5, Color.RED, 3)
		draw_line(Vector2(5,-10), Vector2.UP * 15.5, Color.RED, 3)
