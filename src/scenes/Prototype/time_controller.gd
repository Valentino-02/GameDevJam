class_name TimeController extends Node

@export_group("Timings")
@export_range(1,200,1,"suffix:s","or_greater") var starting_time: float = 10
@export_range(1,50,1,"suffix:s","or_greater") var time_per_cargo: float = 10

@export_group("References")
@export var game_over_title: Label
@export var time_label: Label

var timer: float
var running: bool = true

signal timeout

# --- replace with start mechanic ---
func _ready() -> void:
	new_game()
# -----------------------------------

#Public Functions
func new_game() -> void:
	game_over_title.hide()
	_start_timer(starting_time)
	
func collect_cargo() -> void:
	_add_time(time_per_cargo)
	
func pause_timer(pause:bool) -> void:
	running = pause
	
#Private Functions
func _start_timer(time: float) -> void:
	timer = time

func _add_time(time: float) -> void:
	timer += time

func _process(delta: float) -> void:
	if running:
		timer -= delta
		_update_timer_display()
		if timer <= 0:
			running = false
			timeout.emit()
		
func _update_timer_display() -> void:
	time_label.text = str(roundi(timer))+"s"