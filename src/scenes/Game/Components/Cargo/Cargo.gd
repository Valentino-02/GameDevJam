class_name Cargo extends RigidBody2D

@onready var collision: CollisionShape2D = get_node("CollisionShape2D")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var particles: GPUParticles2D = get_node("GPUParticles2D")


func destroy() -> void:
	sprite.visible = false
	particles.restart()
	await particles.finished
	queue_free()
