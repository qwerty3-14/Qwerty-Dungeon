@icon("uid://bprqcft4duss6")
extends Skill

var event_queued : bool = false

func _on_damage_reciever_object_damaged(_damage: Damage, _combat_object: CombatObject) -> void:
	if _combat_object.health.current <= 0:
		if _damage.actor_source and _damage.action_source and _damage.actor_source == actor_parent and _damage.from_spell() and not event_queued:
			event_queued = true
			var event : CombatEvent = KillingFlowEvent.new(_damage.action_source)
			event.timeout.connect(_on_event_finished)
			CombatEventManager.add_and_start_combat_event(event)




func _on_event_finished():
	event_queued = false
