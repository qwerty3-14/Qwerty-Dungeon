@icon("uid://cpwi6gtpv3s35")
extends Skill

const STATUS_EFFECT = preload("uid://b0ptsgat8x7r1")
const IMBUE_STATUS_EFFECT = preload("uid://cm75pqwmo15g8")

func _actor_description(_actor : Actor) -> String:
	match %Potion.current_mode:
		Potion.modes.DRINK:
			return "[p]" + _actor.character_name + " gains 4 defense for 5 turns[/p]"
		Potion.modes.IMBUE:
			return "[p]The next 3 weapon attacks apply 4 defense for 5 turns[/p]"
	return description


func _on_action_used(action: Action) -> void:
	var status := STATUS_EFFECT.instantiate()
	combat_object_grandparent.apply_status_effect(status)
	action.finish()


func _on_potion_imbue_confirmed() -> void:
	var status := IMBUE_STATUS_EFFECT.instantiate()
	combat_object_grandparent.apply_status_effect(status)
	$Action.start_cooldown()
	
