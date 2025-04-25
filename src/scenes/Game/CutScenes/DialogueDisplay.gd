class_name DialogueDisplay extends Control

signal dialogueComplete
@export var hideWhileTalking: Array[Node]

@onready var textDisplay: RichTextLabel = get_node("VBoxContainer/MarginContainer/DialogueDisplay/VBoxContainer/Panel/MarginContainer/RichTextLabel")
@onready var spriteDisplay: AnimatedSprite2D = get_node("VBoxContainer/MarginContainer/DialogueDisplay/AnimatedSprite2D")
@onready var nextDisplay: RichTextLabel = get_node("VBoxContainer/MarginContainer/DialogueDisplay/Next")

var interrupted: bool = false
var speedPerLetter: float = 0.02
var holdPanel: bool = false

func PlayDialogue(dialogue: Dialogue, keepPanelUp = false) -> void:
	interrupted = false
	holdPanel = keepPanelUp
	textDisplay.text = ""
	if dialogue.speaker != null:
		spriteDisplay.sprite_frames = dialogue.speaker
		spriteDisplay.play("default")
		spriteDisplay.show()
	else:
		spriteDisplay.hide()
	show()
	var _isTag:= false
	for i in range(dialogue.dialogueLine.length()):
		if interrupted: break
		if _isTag:
			if dialogue.dialogueLine[i] == "]":
				_isTag = false
			continue
		if dialogue.dialogueLine[i] == "[":
			_isTag = true
			continue
		textDisplay.text = dialogue.dialogueLine.substr(0,i)
		await get_tree().create_timer(speedPerLetter).timeout
	interrupted = true
	nextDisplay.show()
	textDisplay.text = dialogue.dialogueLine
	
func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton):
		if event.is_released():
			if event.is_action("ui_cancel"):
				CutsceneManager.QuitCutscene()
			elif interrupted:
				_closeDialogue()
			else:
				interrupted = true

func _closeDialogue() -> void:
	if !holdPanel:
		hide()
	dialogueComplete.emit()
	nextDisplay.hide()
	
func Declutter(shouldHide: bool) -> void:
	for node: Node in hideWhileTalking:
		node.visible = !shouldHide
			
