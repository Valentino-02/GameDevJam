class_name Dialogue extends Resource

enum character {
	NONE,
	FIRE,
	WATER
}
@export var speakingCharacter: character

var speaker: Texture2D:
	get:
		match speakingCharacter:
			character.FIRE:
				return PreloadedResources.fireCharacter
			character.WATER:
				return PreloadedResources.waterCharacter
			_:
				return null
@export_multiline var dialogueLine: String