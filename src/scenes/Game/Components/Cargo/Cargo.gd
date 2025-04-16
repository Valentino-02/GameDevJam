class_name Cargo extends RigidBody2D

@onready var collision: CollisionShape2D = get_node("CollisionShape2D")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var particles: GPUParticles2D = get_node("GPUParticles2D")

@onready var l_string: Line2D = get_node("Parachute String L")
@onready var r_string: Line2D = get_node("Parachute String R")
@onready var parachute_sprite: Sprite2D = get_node("ParachuteSprite")

@export var respawn : bool = true

func destroy() -> void:
	sprite.visible = false
	particles.restart()
	await particles.finished
	queue_free()


##Called by the box recovery mechanic to teleport the cargo back to the top
func queueTeleport(pos : Vector2 = global_position, vel : Vector2 = linear_velocity, rot : float = global_rotation, angular_vel : float = angular_velocity, parachute : bool = false):
	_queued = true
	_queued_pos = pos
	_queued_rot = rot
	_queued_vel = vel
	_queued_angular_vel = angular_vel
	setParachute(parachute)
	
##Makes the parachute visible and slows the cargo's speed
func setParachute(enabled : bool = true):
	_setParachuteVisibility(enabled)
	_parachute = enabled
	self.gravity_scale = 0.5 if enabled else 1.0

##Need to store these until the game loop calls integrate forces
var _queued : bool = false
var _queued_pos : Vector2
var _queued_rot : float
var _queued_vel : Vector2
var _queued_angular_vel : float
var _parachute : bool = false
@export var parachute_speed_limit : float = 35.0
##changes the body in the physics simulation, hopefully the rest of the node goes with it?
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _queued:
		state.transform = Transform2D(_queued_rot, _queued_pos)
		state.linear_velocity = _queued_vel
		state.angular_velocity = _queued_angular_vel
		_queued = false
	if _parachute:
		state.linear_velocity = state.linear_velocity.limit_length(parachute_speed_limit)

func _onBodyEntered(body : Node2D):
	##exclude hitting other cargo
	if _parachute and ((body is RigidBody2D and not body is Cargo) or body is TileMap) :
		self.gravity_scale = 1.0
		_setParachuteVisibility(false)
		_parachute = false

##How long a cargo needs to be stationary before the parachute dissapearing
@export var at_rest_duration : float = 2
var _at_rest_counter : float = 0

func _physics_process(delta: float) -> void:
	if _parachute:
		_checkAtRest(delta)
		##TODO fix this Simulate some wind every now and then
		#if (randi() % 250 == 0): _apply_random_force()
		_updateParachuteAnimation()

		

##turns the parachute off if we are stationary
func _checkAtRest(delta : float):
	if linear_velocity.length_squared() < 0.25:
		_at_rest_counter += delta
		if _at_rest_counter > at_rest_duration:
			setParachute(false)
			_at_rest_counter = 0
	else: _at_rest_counter = 0
	
			
			
##applies a random force at a random position to simulate a bit of wind, its kind of awful tho
func _applyRandomForce(x_strength = 1000, y_strength = 5, x_range = 0, y_range = 0, max_duration : int = 30):
	var strength : Vector2 = Vector2(randf_range(-x_strength, x_strength),randf_range(-y_strength, y_strength))
	var pos : Vector2 = Vector2(randf_range(-x_range, x_range),randf_range(-y_range, y_range))
	var wait = get_tree().physics_frame
	for i in range(randi() % max_duration):
		if is_queued_for_deletion(): return #can coroutines get stranded?
		self.apply_force(strength)
		await wait


@export var parachute_string_length : float = 55
##Positions the parachute to be directly above and upright regardless of cargo orienation, also draws the strings properly
func _updateParachuteAnimation():
	parachute_sprite.global_rotation = 0
	parachute_sprite.global_position = self.global_position + (Vector2.UP * parachute_string_length)
	#shrink the width by more than half so that way the ends stick inside the parachute
	var width : Vector2 = Vector2(parachute_sprite.texture.get_width()/2.2, 0)
	l_string.points = [Vector2.ZERO, to_local(parachute_sprite.global_position - width)]
	r_string.points = [Vector2.ZERO, to_local(parachute_sprite.global_position + width)]
##Makes the parachute and strings vertical
func _setParachuteVisibility(visibility : bool):
	parachute_sprite.visible = visibility
	l_string.visible = visibility
	r_string.visible = visibility
