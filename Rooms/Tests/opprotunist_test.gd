extends Room

func _ready() -> void:
	SkillLibrary.give_skill_to_actor(%Narine.get_node("Actor"), "Opportunist")
