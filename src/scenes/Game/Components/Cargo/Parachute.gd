##IMPORTANT: the Parachute node is purely visual, adding it or removing it doesn't effect the cargo. That said, on addition and removal, it toggles the parent cargo's parachuting boolean
class_name Parachute extends Node2D

@onready var l_string: Line2D = get_node("Parachute String L")
@onready var r_string: Line2D = get_node("Parachute String R")

var _cargo : Cargo
var _state : State
enum State {none, attached, waiting, leaving}

var _at_rest_counter : float = 0

#how long without moving before disabling the parachute
const at_rest_duration : float = 0.4
const parachute_string_length : float = 35
const dissapearSpeed : float = 155


func _ready() -> void:
	if not _cargo and get_parent() is Cargo: addToCargo(get_parent())
	await get_tree().physics_frame
	await get_tree().physics_frame
	self.visible = true

#Adds the parachute to the cargo
func addToCargo(cargo : Cargo):
	_cargo = cargo
	if not get_parent(): _cargo.add_child(self)
	_cargo._parachute = true
	_cargo.gravity_scale = 0.3
	_cargo.body_entered.connect(_onBodyEntered)
	_state = State.attached
	if is_inside_tree(): _updateParachuteAnimation()

#removes the parachute from the cargo
func _removeFromCargo(delay = null):
	#ensure we aren't called twice
	if _state != State.attached: return

	#pause for dramatic effect
	if delay:
		_state = State.waiting
		await get_tree().create_timer(delay).timeout

	#remove from the cargo (let it fly away)
	_state = State.leaving
	self.visible = false
	self.reparent(_cargo.get_parent(), true)
	l_string.visible = false
	r_string.visible = false
	if _cargo:#fix the cargo to not parachute state
		_cargo._parachute = false
		_cargo.gravity_scale = 1
		_cargo.body_entered.disconnect(_onBodyEntered)
		_cargo = null
	self.visible = true
	#remove from scene after its done flying
	await get_tree().create_timer(10).timeout
	self.queue_free()


func _physics_process(delta: float) -> void:
	match _state:
		State.attached:
			_updateParachuteAnimation()
			if _checkAtRest(delta) : _removeFromCargo()
		State.leaving: #if theres no cargo, float away
			self.global_position += Vector2.UP * dissapearSpeed * delta
			self.global_rotation = 0
		State.waiting: #drift down before releasing
			self.global_position -= Vector2.UP * dissapearSpeed * 0.7 * delta
			_updateParachuteAnimation(false)


##turns the parachute off if we are stationary
func _checkAtRest(delta : float) -> bool:
	if _cargo.linear_velocity.length_squared() < 0.25:
		_at_rest_counter += delta
		if _at_rest_counter > at_rest_duration:
			return true
	else: _at_rest_counter = 0
	return false

##Positions the parachute to be directly above and upright regardless of cargo orienation, also draws the strings properly
func _updateParachuteAnimation(pos : bool = true):
	self.global_rotation = 0
	if pos: self.global_position = _cargo.global_position + (Vector2.UP * parachute_string_length)
	l_string.points = [Vector2.ZERO, l_string.to_local(_cargo.global_position)]
	r_string.points = [Vector2.ZERO, r_string.to_local(_cargo.global_position)]


func _onBodyEntered(body : Node2D):
	if (body is RigidBody2D and not body is Cargo): #hitting the platform most likely
		_removeFromCargo(0.15)
	elif body is TileMap: #hitting land
		_removeFromCargo(0.15)
	elif (body is Cargo and body._parachute == false): # hitting cargo at rest
		_removeFromCargo(0.15)
