extends Control

@export var terrainColor: Color
@export var zoom: float = 1.0

##Using the in-built groups as keys, and the color for icon on the minimap
@export var poiGroups: Dictionary[StringName, Color]

@onready var level: Node2D = get_node("/root/Game/Level")
@onready var camera  = get_node("/root/Game/Camera2D")

var _tilemaps: Array[TileMapLayer] = []
var _pointsOfInterest: Dictionary[Node, Color] = {}
var _cellColors: Dictionary[int, Color]

var _refreshRate:float = 0.05
var _timer: float      = 0

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("IncludeOnMinimap"):
		for group in node.get_groups():
			if poiGroups.keys().has(group):
				_pointsOfInterest[node] = poiGroups[group]
				break
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
	var first_draw = true
	var cameraPosition = camera.get_screen_center_position()
	for tilemap in _tilemaps:
		var cameraCell: Vector2i    = tilemap.local_to_map(tilemap.to_local(cameraPosition))
		var tilemapOffset: Vector2i = (Vector2i(cameraPosition) - tilemap.local_to_map(cameraCell)) / tilemap.tile_set.tile_size
		
		for id in _cellColors.keys():
			var color = _cellColors[id]
			var cells = _get_cells(tilemap, id)
			for cell in cells:
				draw_rect(Rect2((cell - tilemapOffset) * zoom, Vector2.ONE * zoom), color)
			
		if first_draw:
			first_draw = false
			for poi in _pointsOfInterest.keys():
				var color = _pointsOfInterest[poi]
				var _pos = poi.position
				draw_circle((tilemap.local_to_map(Vector2i(_pos))- tilemapOffset)*zoom, zoom*12, color)
			
			
	

func _physics_process(_delta: float) -> void:
	if _timer < _refreshRate:
		_timer += _delta
		if _timer >= _refreshRate:
			_timer = 0
			queue_redraw()
