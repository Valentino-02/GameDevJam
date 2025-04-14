extends StaticBody2D

@export_group("References")
@export var label: Label
@export var collection_zone: Area2D

var current_total:int = 0

func _ready() -> void:
	label.text = str(current_total)
	collection_zone.body_entered.connect(_object_entered)


func _object_entered(object: Node2D) -> void:
	if object.get_groups().has("Cargo"):
		var cargo: Cargo = object as Cargo
		cargo.destroy()
		_score()
		
func _score() -> void:
	current_total +=1
	label.text = str(current_total)