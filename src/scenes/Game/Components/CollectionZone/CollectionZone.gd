class_name CollectionZone extends Area2D

@export var zone : Types.Zone

func _on_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Cargo"):
		var cargo: Cargo = body as Cargo
		cargo.queue_free()
		SignalBus.zoneGotCargo.emit(zone)
