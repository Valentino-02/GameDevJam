class_name DialogueDisplay extends Control

signal dialogueComplete
@export var hideWhileTalking: Array[Node]

@onready var textDisplay: RichTextLabel = get_node("VBoxContainer/MarginContainer/DialogueDisplay/VBoxContainer/Panel/MarginContainer/RichTextLabel")
@onready var spriteDisplay: TextureRect = get_node("VBoxContainer/MarginContainer/DialogueDisplay/TextureRect")

var interrupted: bool = false
var speedPerLetter: float = 0.02
var holdPanel: bool = false

func PlayDialogue(dialogue: Dialogue, keepPanelUp = false) -> void:
	interrupted = false
	holdPanel = keepPanelUp
	textDisplay.text = ""
	if dialogue.speaker != null:
		spriteDisplay.texture = dialogue.speaker	
		spriteDisplay.show()
	else:
		spriteDisplay.hide()
	show()
	for i in range(dialogue.dialogueLine.length()):
		if interrupted: break
		textDisplay.text = dialogue.dialogueLine.substr(0,i)
		await get_tree().create_timer(speedPerLetter).timeout
	interrupted = true
	textDisplay.text = dialogue.dialogueLine
	
func _input(event: InputEvent) -> void:
	if event.is_action("Drop") && Input.is_action_just_pressed("Drop"):
		if interrupted:
			_closeDialogue()
		else:
			interrupted = true

func _closeDialogue() -> void:
	if !holdPanel:
		hide()
	dialogueComplete.emit()
	
func Declutter(shouldHide: bool) -> void:
	for node: Node in hideWhileTalking:
		node.visible = !shouldHide
			
