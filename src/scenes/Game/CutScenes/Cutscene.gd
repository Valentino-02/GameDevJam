@tool
class_name Cutscene extends Node2D

enum triggerType {
	TRIGGER_ON_ZONE,
	TRIGGER_ON_READY,
	TRIGGER_MANUALLY
}
##If using "trigger on zone" behaviour, please add a trigger zone.
@export var type: triggerType = triggerType.TRIGGER_MANUALLY: 
	set(value):
		type = value
		update_configuration_warnings()

##Dialogue points to use
@export var storyPoints: Array[StoryPoint] = []
##Cameras to use for each story point
@export var useableCameras: Dictionary[StringName, PhantomCamera2D] = {}
@export var keepActive: Array[Node2D] = []

@export_group("For use with zones")
##collisions to detect for zone type triggers
@export_flags_2d_physics var collisionLayers

var triggerZone: Area2D
var _cutscenePlayed := false


func _ready() -> void:
	if Engine.is_editor_hint(): return
	triggerZone = get_node_or_null("Area2D")
	await SignalBus.levelLoaded
	if type == triggerType.TRIGGER_ON_READY:
		_triggerCutscene()
	elif type == triggerType.TRIGGER_ON_ZONE:
		if triggerZone == null:
			push_warning("Trigger area not created for cutscene on %s."%[name])
			return
		triggerZone.collision_mask = collisionLayers
		triggerZone.body_entered.connect(_areaTrigger)
		
		
func _triggerCutscene() -> void:
	if _cutscenePlayed: return
	_cutscenePlayed = true
	CutsceneManager.PlayCutscene(self)
	
func ManualTrigger() -> void:
	_triggerCutscene()
	
func _areaTrigger(node2d: Node2D) -> void:
	if node2d.get_groups().has("PlayerPlatform"):
		_triggerCutscene()
		
func _get_configuration_warnings():
	if type == triggerType.TRIGGER_ON_ZONE:
		triggerZone = get_node_or_null("Area2D")
		if triggerZone == null:
			return ["No area has been set for triggering!"]
	return []
