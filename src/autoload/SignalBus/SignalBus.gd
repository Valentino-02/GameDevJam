extends Node

@warning_ignore_start("unused_signal")
signal zoneGotCargo(zone: Types.Zone)
signal zonePatienceChanged(zone: Types.Zone, value: float)
signal zoneScoreChanged(zone: Types.Zone, value: float)
signal zoneScoreMaxed(zone: Types.Zone)
signal maxScoreSetted(value: float)
signal restart
signal game_over
