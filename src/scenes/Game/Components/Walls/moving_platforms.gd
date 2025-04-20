extends Path2D

@export var speed : float = 15
@onready var _follow : PathFollow2D = get_node("PathFollow2D")


func _physics_process(delta: float) -> void:
    _follow.progress += delta * speed