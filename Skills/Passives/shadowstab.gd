@icon("uid://xc3sso2q65eo")
extends Skill

func _on_aquired_by_actor():
	for skill : Skill in actor_parent.get_children():
		if skill.display_name == "Shadow Strike":
			skill.shadow_stab = true
	actor_parent.learned_skill.connect(_on_actor_aquired_skill)

func _on_actor_aquired_skill(_skill : Skill):
	if _skill.display_name == "Shadow Strike":
		_skill.shadow_stab = true
