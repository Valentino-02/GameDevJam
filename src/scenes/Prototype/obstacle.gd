extends Path2D

@export var obstacle_sprite_res: Texture2D
@export var speed: float
@onready var path_follow: PathFollow2D = get_node("PathFollow2D")
@onready var sprite: Sprite2D = get_node("Sprite2D")

var _invert_direction: bool = false

func _ready() -> void:
	if obstacle_sprite_res != null: sprite.texture = obstacle_sprite_res

func _physics_process(delta: float) -> void:
	_move_obstacle(delta)
	
func _move_obstacle(delta: float) -> void:
	if _invert_direction:
		path_follow.progress_ratio -= (delta * speed)
		if path_follow.get_progress_ratio() <= 0:
			_invert_direction = false
	else:
		path_follow.progress_ratio += (delta*speed)
		if path_follow.get_progress_ratio() >= 1:
			_invert_direction = true