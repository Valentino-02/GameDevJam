extends Camera2D

@export var cargo_scene : PackedScene
@export var left_character : Character
@export var right_character : Character
@export var ropes : Array[Rope] = []
@export var strength: float = 300.0
@export var max_distance = 0

func _process(delta):
	if Input.is_action_just_pressed("Click"):
		var cargo : Node2D = cargo_scene.instantiate()
		get_parent().add_child(cargo)
		cargo.global_position = get_global_mouse_position()

func _ready() -> void:
	if max_distance == 0: max_distance = get_max_distance()
		

func get_max_distance() -> float:
	var attachements : Array[Vector2] = []
	var distance : float = 0
	for rope in ropes:
		distance += rope.spring_length
		attachements.append(rope.platform_attachement.global_position)
	distance += (attachements[0] - attachements[1]).length()
	return distance


func _physics_process(delta: float) -> void:
	for suffix in ["L", "R"]:
		var force : Vector2 = get_input_vector(suffix) * strength
		var difference : Vector2 = right_character.global_position - left_character.global_position
		if suffix == "L": difference *= -1
		if difference.length() > max_distance:
			#subtract the force component that is in the away direction
			var direction : Vector2 = difference.normalized()
			force = force - (max(force.dot(direction),0) * direction)
			
		if suffix == "L": left_character.apply_force(force)
		else: right_character.apply_force(force)
		




##TODO if the distance between the two characters is greater than the rope length + platform length then dampen the acceleration?

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
