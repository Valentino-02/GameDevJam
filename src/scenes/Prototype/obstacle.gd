extends Path2D

##sprite for the obstacle to display
@export var obstacle_sprite_res: Texture2D

##obstacle movement speed
@export var speed: float

@export_group("References")
@export var sprite: Sprite2D
@export var path_follow: PathFollow2D

var _invert_direction: bool = false

func _ready() -> void:
	if obstacle_sprite_res != null: sprite.texture = obstacle_sprite_res

func _physics_process(delta: float) -> void:
	_move_obstacle(delta)
	
func _move_obstacle(delta: float) -> void:
	if _invert_direction:
		path_follow.progress -= (delta * speed)
		if path_follow.get_progress_ratio() <= 0:
			_invert_direction = false
	else:
		path_follow.progress += (delta*speed)
		if path_follow.get_progress_ratio() >= 1:
			_invert_direction = true