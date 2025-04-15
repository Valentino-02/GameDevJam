class_name Cargo extends RigidBody2D

var base_sprite_scale:float = 0.172
var pick_up := false
var mouse_over := false

@onready var collision: CollisionShape2D = get_node("CollisionShape2D")
@onready var sprite: Sprite2D = get_node("Sprite2D")

func _mouse_enter() -> void:
	mouse_over = true
	
func _mouse_exit() -> void:
	mouse_over = false

func _input(event: InputEvent) -> void:
	if mouse_over && Input.is_action_just_pressed("Click"):
		print("Clicked")
		pick_up = true
	elif event.is_action("Click") && !event.is_pressed():
		print("unclicked")
		pick_up = false
		
func _physics_process(delta: float) -> void:
	if pick_up:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		
func set_cargo_scale(target: Vector2) -> void:
	collision.scale = target
	sprite.scale = target * base_sprite_scale
	
func destroy() -> void:
	##TODO: logic for any animations upon death
	await get_tree().create_timer(2).timeout
	queue_free()