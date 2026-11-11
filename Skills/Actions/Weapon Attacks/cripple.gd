@icon("uid://chhpmu8nqnw2d")
extends Skill

var CRIPPLE_STATUS := preload("uid://1ix7e4nrd3k")
var cripple_status_icon : Texture2D = preload("uid://bovujxsew4xsb")


func _on_queued_weapon_attack(weapon_attack_event : WeaponAttackEvent):
	weapon_attack_event.target_been_first_hit.connect(_on_target_hit)
	combat_object_grandparent.queued_weapon_attack.disconnect(_on_queued_weapon_attack)

func _on_target_hit(target : CombatObject):
	if target.has_node("Actor"):
		var actor : Actor = target.get_node("Actor")
		if actor.resilience.value < actor_parent.might.value:
			actor.cur_mp = 0
		target.apply_status_effect_resistable(CRIPPLE_STATUS.instantiate(), actor_parent.might.value)



func _on_action_used(_action: Action) -> void:
	combat_object_grandparent.queued_weapon_attack.connect(_on_queued_weapon_attack)

func _on_action_ai_used(_action: Action, _steps: Array) -> void:
	combat_object_grandparent.queued_weapon_attack.connect(_on_queued_weapon_attack)


func _on_action_ended() -> void:
	if combat_object_grandparent.queued_weapon_attack.is_connected(_on_queued_weapon_attack):
		combat_object_grandparent.queued_weapon_attack.disconnect(_on_queued_weapon_attack)


func _on_modified_weapon_attack_about_to_score(rival: CombatObject, target_ai: SingleTargetAI) -> void:
	if rival.has_node("Actor"):
		var actor : Actor = rival.get_node("Actor")
		if actor.resilience.value >= actor_parent.might.value:
			target_ai.about_to_score_multiplier_SR *= 0.95
		else:
			target_ai.about_to_score_damage_modifier_SR += (actor.cur_mp + actor.max_mp) * 0.1
