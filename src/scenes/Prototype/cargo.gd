extends RigidBody2D

var pick_up := false
var mouse_over := false

#func _on_area_2d_input_event(_viewport, _event, _shape_idx):
#	#implement pickup behaviour
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