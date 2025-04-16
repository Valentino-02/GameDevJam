extends Area2D

@onready var platform : RigidBody2D = get_node("../PlayerCharacter/Platform")


##Connected in editor to the body_entered signal of the floor
func _onFloorBodyEntered(body : Node2D):
	if body is Cargo:
		##Centered on the platform is likely more ideal
		#var pos : Vector2 = Vector2(body.global_position.x, self.global_position.y)
		var pos : Vector2 = Vector2(platform.global_position.x, self.global_position.y)
		body.queueTeleport(pos, Vector2.ZERO, 0, 0, true)
