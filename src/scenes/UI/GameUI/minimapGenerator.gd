extends Control

@export var terrainColor: Color
@export var zoom: float = 1.0

@onready var level: Node2D = get_node("/root/Game/Level")
@onready var camera  = get_node("/root/Game/Camera2D")

var _tilemaps: Array[TileMapLayer] = []
var _cellColors: Dictionary[int, Color]

var _refreshRate:float = 0.05
var _timer: float      = 0

func _ready() -> void:
	for child in level.get_children():
		if child is TileMapLayer:
			_tilemaps.append(child)
	for map in _tilemaps:
		for n in map.tile_set.get_source_count():
			_cellColors[map.tile_set.get_source_id(n)] = terrainColor
			
func _get_cells(tilemap : TileMapLayer, id) -> Array[Vector2i]:
	return tilemap.get_used_cells_by_id(id)

func _draw() -> void:
	draw_set_transform(size / 2, 0, Vector2.ONE)

	for tilemap in _tilemaps:
		var cameraPosition          = camera.get_screen_center_position()
		var cameraCell: Vector2i    = tilemap.local_to_map(tilemap.to_local(cameraPosition))
		var tilemapOffset: Vector2i = (Vector2i(cameraPosition) - tilemap.local_to_map(cameraCell)) / tilemap.tile_set.tile_size
		
		for id in _cellColors.keys():
			var color = _cellColors[id]
			var cells = _get_cells(tilemap, id)
			for cell in cells:
				draw_rect(Rect2((cell - tilemapOffset) * zoom, Vector2.ONE * zoom), color)


func _physics_process(_delta: float) -> void:
	if _timer < _refreshRate:
		_timer += _delta
		if _timer >= _refreshRate:
			_timer = 0
			queue_redraw()
