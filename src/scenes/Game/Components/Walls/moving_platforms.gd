extends Path2D

@export var speed : float = 15
@onready var _follow : PathFollow2D = get_node("PathFollow2D")

var tilemap: TileMapLayer:
	get:
		return _follow.get_node("TileMapLayer")

func _physics_process(delta: float) -> void: 
	_follow.progress += delta * speed