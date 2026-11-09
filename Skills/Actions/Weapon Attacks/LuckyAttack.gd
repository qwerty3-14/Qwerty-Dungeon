@icon("uid://skcqflhqernq")
extends Skill

const LUCKY_CHARGE := preload("uid://b1vwaags3cp7w")

func _on_aquired_by_actor():
	Globals.combat_main.phase_starting.connect(_on_phase_start)

func _on_phase_start():
	combat_object_grandparent.apply_status_effect(LUCKY_CHARGE.instantiate())

func _on_action_inputs_done() -> void:
	var lucky_charge : StatusEffect = combat_object_grandparent.get_node("LuckyCharge")
	lucky_charge.reduce_duration()
	Globals.actions_menu.reload_status()


func _on_checking_playable() -> void:
	if not combat_object_grandparent.has_node("LuckyCharge"):
		show_playable = false
