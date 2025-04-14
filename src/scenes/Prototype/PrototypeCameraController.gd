class_name CameraController extends Camera2D

@export var cargo_scene : PackedScene
@export var left_character : Character
@export var right_character : Character
@export var left_rope : Rope
@export var right_rope : Rope

##Player's move force
@export var strength: float = 400.0
##How much the player can stretch the rope before inputs get ignored
@export var player_leash_multiplier : float = 1.3
##When exceeding the leash distance, player_dampening * relative velocity acts as a restorative force.
@export var player_dampening : float = 2

##How much the upwards lift should be added in order to counteract gravity, 1 is no additional lift, 0 is no lift at all
@export var lift_multiplier : float = 3

func _process(delta):
	drop_cargo_if_input()
	center_camera(delta)

@export var camera_smoothing_speed : float = 3

func center_camera(delta : float):
	var midpoint : Vector2 = (left_character.global_position + right_character.global_position + right_rope.platform.global_position) / 3.0
	self.global_position = self.global_position.lerp(midpoint, camera_smoothing_speed * delta )

func drop_cargo_if_input() -> bool:
	if Input.is_action_just_pressed("RightClick"):
		var cargo : Node2D = cargo_scene.instantiate()
		get_parent().add_child(cargo)
		cargo.global_position = get_global_mouse_position()
		return true
	return false


func _physics_process(delta: float) -> void:
	handle_character_movement()
		
func handle_character_movement():
	for suffix in ["L", "R"]:
		##Select the right character and their rope
		var character : Character = right_character
		var rope : Rope = right_rope
		var force : Vector2 = get_input_vector(suffix) * strength
		if suffix == "L": 
			character = left_character
			rope = left_rope

		##adds extra lift
		force += get_component_along_direction(force, Vector2.UP) * (lift_multiplier - 1)

		##Dampen the input and the velocity if the rope is too stretched
		var difference : Vector2 = character.global_position - rope.platform_attachement.global_position
		var direction : Vector2 = difference.normalized()
		if difference.length() > rope.spring_length * player_leash_multiplier:
			force -= get_component_along_direction(force, direction)
			
		force -= get_component_along_direction(character.linear_velocity, direction) * player_dampening
		
		
		character.apply_force(force)


static func get_component_along_direction(force: Vector2, direction : Vector2) -> Vector2:
	return (max(force.dot(direction), 0) * direction)

func get_input_vector(suffix : String) -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO

	if Input.is_action_pressed("Right " + suffix):
		input_vector.x += 1
	if Input.is_action_pressed("Left " + suffix):
		input_vector.x -= 1
	if Input.is_action_pressed("Down " + suffix):
		input_vector.y += 1
	if Input.is_action_pressed("Up " + suffix):
		input_vector.y -= 1

	return input_vector.normalized()
