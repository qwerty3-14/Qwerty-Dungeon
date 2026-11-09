@icon("uid://cwa1wtuh653do")
extends Skill


func _on_damage_reciever_object_about_to_be_damaged(_damage: Damage, _combat_object: CombatObject) -> void:
	if _damage.actor_source and _damage.actor_source == actor_parent and _damage.from_spell():
		if Globals.rng.randi_range(0, 99) < actor_parent.luck.value:
			_damage.amount *= 3
