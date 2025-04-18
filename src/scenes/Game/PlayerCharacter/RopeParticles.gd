extends GPUParticles2D

@onready var _mask: Sprite2D = get_parent()
@onready var _rope : Rope = get_parent().get_parent()

func _ready() -> void:
	emitting = true
	
func _physics_process(_delta: float) -> void:
	_mask.position = _rope.points[0]
	_mask.rotation = _rope.points[0].direction_to(_rope.points[1]).angle()
	_mask.texture.size.x = _rope.points[0].distance_to(_rope.points[1])
	

	