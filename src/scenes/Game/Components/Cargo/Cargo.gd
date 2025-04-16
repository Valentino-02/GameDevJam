class_name Cargo extends RigidBody2D

@onready var collision: CollisionShape2D = get_node("CollisionShape2D")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var particles: GPUParticles2D = get_node("GPUParticles2D")

@onready var l_string: Line2D = get_node("Parachute String L")
@onready var r_string: Line2D = get_node("Parachute String R")
@onready var parachute_sprite: Sprite2D = get_node("ParachuteSprite")




func destroy() -> void:
	sprite.visible = false
	particles.restart()
	await particles.finished
	queue_free()


##Called by the box recovery mechanic to teleport the cargo back to the top
func queueTeleport(pos : Vector2 = global_position, vel : Vector2 = linear_velocity, rot : float = global_rotation, angular_vel : float = angular_velocity, _parachute : bool = false):
	queued = true
	queued_pos = pos
	queued_rot = rot
	queued_vel = vel
	queued_angular_vel = angular_vel
	if _parachute:
		_setParachuteVisibility(true)
		self.parachute = true
		self.gravity_scale = 0.5

##Need to store these until the game loop calls integrate forces
var queued : bool = false
var queued_pos : Vector2
var queued_rot : float
var queued_vel : Vector2
var queued_angular_vel : float
var parachute : bool = false
@export var parachute_speed_limit : float = 35.0
##changes the body in the physics simulation, hopefully the rest of the node goes with it?
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if queued:
		state.transform = Transform2D(queued_rot, queued_pos)
		state.linear_velocity = queued_vel
		state.angular_velocity = queued_angular_vel
		queued = false
	if parachute:
		state.linear_velocity = state.linear_velocity.limit_length(parachute_speed_limit)

func _onBodyEntered(body : Node2D):
	##exclude hitting other cargo
	if parachute and ((body is RigidBody2D and not body is Cargo) or body is TileMap) :
		self.gravity_scale = 1.0
		_setParachuteVisibility(false)
		parachute = false

func _physics_process(delta: float) -> void:
	if parachute:
		##TODO fix this Simulate some wind every now and then
		#if (randi() % 250 == 0): _apply_random_force()
		_updateParachuteAnimation()
		
			
			
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
