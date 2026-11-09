@icon("uid://b0f7ofkxfvrl4")
extends Skill

const STATUS_EFFECT = preload("uid://l2igo7vnudx")
const IMBUE_STATUS_EFFECT = preload("uid://dkl1tdak6djdq")

func _actor_description(_actor : Actor) -> String:
	match %Potion.current_mode:
		Potion.modes.DRINK:
			return"[p]Reduces your pot by 4 for 5 turns.[/p]"
		Potion.modes.IMBUE:
			return "[p]The next 3 weapon attacks gain inflict weakness, reducing pot by 4 for 5 phases[/p]" 
	return description


func _on_action_used(_action: Action) -> void:
	var status := STATUS_EFFECT.instantiate()
	combat_object_grandparent.apply_status_effect(status)
	_action.finish()


func _on_potion_imbue_confirmed() -> void:
	var status := IMBUE_STATUS_EFFECT.instantiate()
	combat_object_grandparent.apply_status_effect(status)
	$Action.start_cooldown()
