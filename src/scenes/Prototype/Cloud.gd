extends AnimatableBody2D

@export var path : PathFollow2D
@export var speed : float = 100

func _physics_process(delta: float) -> void:
	follow_path(delta)

func follow_path(delta : float):
	path.progress += speed * delta
	self.global_position = path.global_position
