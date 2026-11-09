@icon("uid://b6jlsmrkn3vur")
extends Skill

const STATUS_EFFECT = preload("uid://l2igo7vnudx")
const IMBUE_STATUS_EFFECT = preload("uid://wldbcpmn8pbv")

func _actor_description(_actor : Actor) -> String:
	var damage = Damage.new(_actor.potency.value, Damage.Type.POISON, %Action, actor_parent)
	match %Potion.current_mode:
		Potion.modes.DRINK:
			return"[p]" + _actor.character_name + " takes " + str(damage) + "[p]" + _actor.character_name + " recives " + str(damage) + " at the end of the next 5 phases[/p]"
		Potion.modes.IMBUE:
			return "[p]The next 3 weapon attacks gain " + str(damage) +" and inflict poison causing " + str(damage) + " at the end of the next 5 phases[/p]" 
	return description

func _on_action_used(_action: Action) -> void:
	var damage : Damage = Damage.new(actor_parent.potency.value, Damage.Type.POISON, %Action, actor_parent)
	combat_object_grandparent.receive_damage(damage)
	var status := STATUS_EFFECT.instantiate()
	status.damage = damage
	combat_object_grandparent.apply_status_effect(status)
	_action.finish()


func _on_potion_imbue_confirmed() -> void:
	var status := IMBUE_STATUS_EFFECT.instantiate()
	combat_object_grandparent.apply_status_effect(status)
	$Action.start_cooldown()
