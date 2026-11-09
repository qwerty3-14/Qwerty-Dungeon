@icon("uid://dvwrc6kymvnnq")
extends Skill

const CHARGE := preload("uid://caxcw0yl3vujw")

var impalement : Action

func _on_aquired_by_actor():
	for skill : Skill in actor_parent.get_children():
		if skill.display_name == "Impalement":
			impalement = skill.get_node("Action")
	actor_parent.learned_skill.connect(_on_actor_aquired_skill)
	Globals.combat_main.phase_ending.connect(_on_phase_ending)

func _on_actor_aquired_skill(_skill : Skill):
	if _skill.display_name == "Impalement":
		impalement = _skill.get_node("Action")


func _on_phase_ending():
	if impalement.cooldown_counter == 0 and Globals.combat_main.current_phase > 0:
		combat_object_grandparent.apply_status_effect(CHARGE.instantiate())
