extends Room

func _ready() -> void:
	SkillLibrary.give_skill_to_actor(%Scarlet.get_node("Actor"), "Between Tiles Test")
