extends Node2D

@export var phantom_camera : PhantomCamera2D
##how many extra pixels the camera gets too see beyond the boundary walls
@export var border : int = 25

@onready var _floor : StaticBody2D = get_node("Floor")
@onready var _ceiling : StaticBody2D = get_node("Ceiling")
@onready var _left_wall : StaticBody2D = get_node("LeftWall")
@onready var _right_wall : StaticBody2D = get_node("RightWall")


func _ready() -> void:
	phantom_camera.limit_bottom = floor(_floor.global_position.y) + border
	phantom_camera.limit_right = floor(_right_wall.global_position.x) + border
	phantom_camera.limit_top = ceil(_ceiling.global_position.y) - border
	phantom_camera.limit_left = ceil(_left_wall.global_position.x) - border
