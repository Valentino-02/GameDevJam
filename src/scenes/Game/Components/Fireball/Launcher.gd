@tool
class_name Launcher extends Node2D

##How long between each projectile before the next is sent, loops
@export var spawn_pattern : Array[float] = [0.5, 0.5, 1, 1, 3]
##A coefficient for the force of each projectile, loops
@export var speed_pattern : Array[float] = [0.5, 0.5, 1, 1, 1.2]

@onready var _fireballScene = preload("res://src/scenes/Game/Components/Fireball/Fireball.tscn")
@onready var _timer : Timer = get_node("Timer")
var _spawnIdx : int = 0 
var _speedIdx : int = 0 
const SPEED_MULTIPLIER : float = 200

func _get_next(index : int, pattern : Array[float] ) -> float:
	return pattern[index % pattern.size()]

##launches the projectile and restarts the timer
func _onTimerTimeout():
	var speed : float = _get_next(_speedIdx, speed_pattern) * SPEED_MULTIPLIER
	_launchBody(speed)
	_speedIdx += 1 #overflow isn't an issue
	
	_timer.start(_get_next(_spawnIdx, spawn_pattern))
	_spawnIdx += 1 #overflow isn't an issue
	
	
##Spawns the object and sets it in motion
func _launchBody(speed : float):
	var body : Fireball = _fireballScene.instantiate()
	self.add_child(body)
	body.global_position = self.global_position
	body.global_rotation = self.global_rotation
	#took me an embarrassingly long time to figure out that this was the problem
	var direction : Vector2 = to_global(Vector2.UP) - global_position
	body.linearVelocity = direction * speed

	await get_tree().create_timer(60).timeout
	if body: body.queue_free()

##To help us oreintate it in editor only
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, Vector2.UP * 15, Color.RED, 4)
		draw_line(Vector2(-5,-10), Vector2.UP * 15.5, Color.RED, 3)
		draw_line(Vector2(5,-10), Vector2.UP * 15.5, Color.RED, 3)
