@icon("uid://b4q8hr7pyw43i")
extends Skill


func _on_aquired_by_actor():
	if Globals.combat_main:
		Globals.combat_main.phase_zero_starting.connect(_on_phase_zero_starting)
	

func _on_phase_zero_starting(phase_zero_actor_cos : Array[CombatObject]):
	if actor_parent and combat_object_grandparent.is_visible_in_tree():
		actor_parent.cur_mp = actor_parent.max_mp
		phase_zero_actor_cos.append(combat_object_grandparent)
