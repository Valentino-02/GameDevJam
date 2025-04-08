extends Node

var _seed : int

func setSeed(newSeed: int) -> void:
	if _seed != null:
		push_warning("Rng Manager being called to replace the current seed")
	_seed = newSeed

func getSeed() -> int:
	return _seed

func createRng() -> RandomNumberGenerator:
	if _seed == null:
		_seed = 0
		push_warning("RngManager being called to create a generator, witout having a seed set. Seed got set to default value of cero")
	var rng := RandomNumberGenerator.new()
	rng.seed = _seed
	return rng
