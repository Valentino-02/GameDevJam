extends StaticBody2D

@export_range(0,5) var spawn_speed : float
@export var package: PackedScene

var platform_in_position:= false
var ready_to_drop = true

@onready var detection_zone: Area2D = find_child("Area2D")
@onready var timer: Timer = find_child("Timer")
@onready var marker: Marker2D = find_child("Marker2D")

func _ready() -> void:
	detection_zone.body_entered.connect(_object_entered)
	detection_zone.body_exited.connect(_object_exited)
	timer.timeout.connect(func(): ready_to_drop = true)
	
	
func _object_entered(object: Node2D) -> void:
	if object.get_groups().has("PlayerPlatform"):
		platform_in_position = true
		
		
func _object_exited(object: Node2D) -> void:
	if object.get_groups().has("PlayerPlatform"):
		platform_in_position = false
		
func _process(_delta: float) -> void:
	if platform_in_position && ready_to_drop:
		_drop_package()
		
func _drop_package() -> void:
	ready_to_drop = false
	timer.start(spawn_speed)
	var cargo : Node2D = package.instantiate()
	get_parent().add_child(cargo)
	cargo.global_position = marker.global_position