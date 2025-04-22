class_name RopeParticles extends GPUParticles2D

var _mask: Sprite2D = get_parent()
var _rope : Rope

func _ready() -> void:
	emitting = true
	
func _physics_process(_delta: float) -> void:
	if _rope == null: return
	_mask.position = _rope.points[0]
	_mask.rotation = _rope.points[0].direction_to(_rope.points[1]).angle()
	_mask.texture.size.x = _rope.points[0].distance_to(_rope.points[1])

func SetMaskAndRope(mask: Sprite2D, rope: Rope) -> void:
	_mask = mask
	_rope = rope