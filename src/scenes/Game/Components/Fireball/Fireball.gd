class_name Fireball extends Area2D
##a multiplier to the explosion force
@export var explosion_strength : float = 1.0
##(radius-Distance)^power = strength coefficient, 0 = constant, 1 = linear, 2 = quadratic, etc...
@export var strength_fall_off_power : int = 0

@onready var _explosion_emitter : CPUParticles2D = get_node("GPUParticles2D")
@onready var _fireball_sprite : Sprite2D = get_node("FireballSprite")
@onready var _shape_cast : ShapeCast2D = get_node("ShapeCast2D")
@onready var _ray_cast : RayCast2D = get_node("RayCast2D")
const STRENGTH_MULTIPLIER : float = 100

var linearVelocity : Vector2 = Vector2.ZERO
func _physics_process(delta: float) -> void:
	global_position += linearVelocity * delta



##Pushes everything with los to the collision away
func _onCollision(_collided : Node) -> void:
	_explosion_emitter.emitting = true
	_fireball_sprite.visible = false
	AudioManager.sfx.playAtPosition(ResourceIds.SfxId.Explosion, global_position)
	var bodies : Array = _getBodiesInRadius()
	for body in bodies:
		if not body is RigidBody2D or body == self: continue
		if _getRayCast(body) == body:
			var diff : Vector2 = _ray_cast.get_collision_point() - self.global_position
			var explosion_radius : float = _shape_cast.shape.radius
			var force : float = pow(clampf((explosion_radius - diff.length()), 0, explosion_radius)/explosion_radius, strength_fall_off_power) * STRENGTH_MULTIPLIER * explosion_strength
			var direction : Vector2 = diff.normalized()
			body.apply_impulse(direction * force, _ray_cast.get_collision_point())

	await get_tree().create_timer(0.4).timeout
	self.queue_free()

##Finds the first body on the path there
func _getRayCast(body : RigidBody2D):
	_ray_cast.target_position = _ray_cast.to_local(body.global_position)
	_ray_cast.force_raycast_update()
	return _ray_cast.get_collider()

##Detects anybody within the collision radius
func _getBodiesInRadius() -> Array:
	_shape_cast.force_shapecast_update()
	var collision = []
	collision.resize(_shape_cast.get_collision_count())
	for i in range(_shape_cast.get_collision_count()):
		collision[i] = _shape_cast.get_collider(i)
	return collision
