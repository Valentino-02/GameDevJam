class_name Minimap extends Control

@export var terrainColor: Color
@export var zoom: float = 1.0
@export var iconSize: float = 16

var _minimapTargets: Array[Node2D] = []
var _tilemaps: Array[TileMapLayer] = []
var _cellColors: Dictionary[int, Color]
var _refreshRate: float = 0.05
var _timer: float = 0
var _camera: Camera2D
var _poiToTexture: Dictionary[Node,TextureRect]
var _readyToDraw: bool = false
	
func _ready() -> void:
	SignalBus.registerForMinimap.connect(_onMinimapRegister)
	
func _onMinimapRegister(node2d: Node2D) -> void:
	_minimapTargets.append(node2d)
	
func BeginDraw() -> void:
	_clearSavedRects()
	for node in _minimapTargets:
		var texture: Texture2D = null
		if node is CollectionZone:
			if node.neededElement == Types.Element.Fire:
				texture = PreloadedResources.waterCoreTexture
			elif node.neededElement == Types.Element.Water:
				texture = PreloadedResources.fireCoreTexture
		elif node is CargoDropper:
			if node.element == Types.Element.Fire:
				texture = PreloadedResources.fireDropperTexture
			elif node.element == Types.Element.Water:
				texture = PreloadedResources.waterDropperTexture
		else:
			continue
		var textureRect: TextureRect = TextureRect.new()
		textureRect.texture = texture
		textureRect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		textureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		textureRect.size = Vector2(iconSize, iconSize)
		_poiToTexture[node] = textureRect
		add_child(textureRect)
	_readyToDraw = true

func SetTargets(nodes: Array[Node2D]) -> void:
	_minimapTargets = nodes
			
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
	
func _clearSavedRects() -> void:
	if _poiToTexture.size() <= 0 : return
	for key in _poiToTexture.keys():
		_poiToTexture[key].queue_free()
	_poiToTexture.clear()

func _draw() -> void:
	if !_readyToDraw: return
	if !visible: return
	draw_set_transform(size / 2, 0, Vector2.ONE)
	var first_draw: bool        = true
	var cameraPosition: Vector2 = _camera.get_screen_center_position()
	
	for tilemap in _tilemaps:
		var cameraCell: Vector2i = tilemap.local_to_map(tilemap.to_local(cameraPosition))
		var tilemapOffset: Vector2i = ((Vector2i(cameraPosition-tilemap.global_position) - tilemap.local_to_map(cameraCell)) / tilemap.tile_set.tile_size)

		for id in _cellColors.keys():
			var color = _cellColors[id]
			var cells = _getCells(tilemap, id)
			for cell in cells:
				draw_rect(Rect2((cell - tilemapOffset) * zoom, Vector2.ONE * zoom), color)

		if first_draw:
			first_draw = false
			for poi in _poiToTexture.keys():
				var _pos = poi.global_position
				var _targetPoint = ((tilemap.local_to_map(Vector2i(_pos)) - tilemapOffset) * zoom) + (size / 2) - _poiToTexture[poi].size/2
				_poiToTexture[poi].position = _targetPoint
