@icon("uid://c53xuhbko2sw7")
extends Skill

signal potion_to_imbue_requested()
signal imbue_action_ended()





func _on_action_ended() -> void:
	imbue_action_ended.emit()


func _on_action_post_used_setup() -> void:
	potion_to_imbue_requested.emit()

func _on_potion_imbue_confirmed():
	if Globals.combat_main.action_is_active:
		$Action.finish()
	else:
		printerr("This should only happen when action is already active")
