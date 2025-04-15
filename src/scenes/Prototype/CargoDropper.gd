extends StaticBody2D

##delay between box drops
@export_range(0,5,0.1,"suffix:s") var spawn_speed : float

##cargo scene
@export var package: PackedScene

##Maximum scale of the x or y when randomly generating cargo
@export_group("Generation Variables")
@export var max_cargo_scale: int = 3
@export var min_cargo_scale: int = 1
@export var min_cargo_mass: float = 1
@export var max_cargo_mass: float = 10

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
	var cargo : Cargo = package.instantiate()
	get_parent().add_child(cargo)
	cargo.set_cargo_scale(_random_scale())
	cargo.mass = randf_range(min_cargo_mass, max_cargo_mass)
	cargo.global_position = marker.global_position
	
func _random_scale() -> Vector2:
	var x := (randi() % max_cargo_scale)+min_cargo_scale
	var y := (randi() % max_cargo_scale) +min_cargo_scale
	return Vector2(x, y)
