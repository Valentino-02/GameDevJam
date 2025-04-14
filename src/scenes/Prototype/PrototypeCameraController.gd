extends Camera2D

@export var cargo_scene : PackedScene

func _process(delta):
    if Input.is_action_just_pressed("Click"):
        var cargo : Node2D = cargo_scene.instantiate()
        get_parent().add_child(cargo)
        cargo.global_position = get_global_mouse_position()
