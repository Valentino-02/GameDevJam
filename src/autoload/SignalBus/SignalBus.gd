extends Node

@warning_ignore_start("unused_signal")
signal zoneGotCargo(zone: Types.Zone)
signal zonePatienceChanged(zone: Types.Zone, value: float)
signal cargoDroppedOnSurface(hitPoint: Vector2, cargo: Cargo)
signal hazardFixed(element: Types.Element)
signal restart
signal game_over
