class_name Minimap extends Control

@export var terrainColor: Color
@export var zoom: float = 1.0
@export var poiGroups: Dictionary[StringName, Color]

var _tilemaps: Array[TileMapLayer] = []
var _cellColors: Dictionary[int, Color]
var _refreshRate: float = 0.05
var _timer: float = 0
var _camera: Camera2D
var _pointsOfInterest: Dictionary[Node, Color] = {}

#func _ready() -> void:
	#for node in get_tree().get_nodes_in_group("IncludeOnMinimap"):
		#for group in node.get_groups():
			#if poiGroups.keys().has(group):
				#_pointsOfInterest[node] = poiGroups[group]
				#break
			
func _physics_process(_delta: float) -> void:
	if _timer < _refreshRate:
		_timer += _delta
		if _timer >= _refreshRate:
			_timer = 0
			queue_redraw()

func setTilemaps(tileMaps: Array[TileMapLayer]) -> void:
	_tilemaps = tileMaps
	for map in _tilemaps:
		for n in map.tile_set.get_source_count():
			_cellColors[map.tile_set.get_source_id(n)] = terrainColor

func setCamera(camera: Camera2D) -> void:
	_camera = camera

func _getCells(tilemap: TileMapLayer, id) -> Array[Vector2i]:
	return tilemap.get_used_cells_by_id(id)

func _draw() -> void:
	draw_set_transform(size / 2, 0, Vector2.ONE)

	for tilemap in _tilemaps:
		var cameraPosition = _camera.get_screen_center_position()
		var cameraCell: Vector2i = tilemap.local_to_map(tilemap.to_local(cameraPosition))
		var tilemapOffset: Vector2i = (Vector2i(cameraPosition) - tilemap.local_to_map(cameraCell)) / tilemap.tile_set.tile_size

		for id in _cellColors.keys():
			var color = _cellColors[id]
			var cells = _getCells(tilemap, id)
			for cell in cells:
				draw_rect(Rect2((cell - tilemapOffset) * zoom, Vector2.ONE * zoom), color)

#func _draw() -> void:
	#draw_set_transform(size / 2, 0, Vector2.ONE)
	#var first_draw = true
	#var cameraPosition = _camera.get_screen_center_position()
	#for tilemap in _tilemaps:
		#var cameraCell: Vector2i = tilemap.local_to_map(tilemap.to_local(cameraPosition))
		#var tilemapOffset: Vector2i = (Vector2i(cameraPosition) - tilemap.local_to_map(cameraCell)) / tilemap.tile_set.tile_size
		#
		#for id in _cellColors.keys():
			#var color = _cellColors[id]
			#var cells = _getCells(tilemap, id)
			#for cell in cells:
				#draw_rect(Rect2((cell - tilemapOffset) * zoom, Vector2.ONE * zoom), color)
			#
		#if first_draw:
			#first_draw = false
			#for poi in _pointsOfInterest.keys():
				#var color = _pointsOfInterest[poi]
				#var _pos = poi.position
				#draw_circle((tilemap.local_to_map(Vector2i(_pos)) - tilemapOffset) * zoom, zoom * 12, color)
