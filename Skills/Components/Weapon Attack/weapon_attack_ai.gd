extends Node

signal about_to_score(rival : CombatObject, target_ai : SingleTargetAI)

var action : Action
var skill_parent : Skill
var weapon_attack_parent : BaseWeaponAttack
var damage_type : Damage.Type = Damage.Type.CRUSHING
var repeats : int = 0

func setup(_skill_parent : Skill, _action : Action, _target_range : TargetRange, _damage_type : Damage.Type, _repeats : int = 0):
	%SingleTargetAttackAI.setup(_skill_parent, _action, _target_range)
	skill_parent = _skill_parent
	action = _action
	repeats = _repeats
	if get_parent() is BaseWeaponAttack:
		weapon_attack_parent = get_parent()
	else:
		printerr("Need BaseWeaponAttack Parent")

func _on_single_target_attack_ai_ready_to_use_action(_tile_pos: Vector2i) -> void:
	if weapon_attack_parent.try_to_attack_position(_tile_pos):
		action.finish()
	else:
		action.cancel()


func _on_single_target_attack_ai_update_my_damage() -> void:
	%SingleTargetAttackAI.damage = Damage.new(skill_parent.actor_parent.might.value, damage_type, action, skill_parent.actor_parent)


func _on_single_target_attack_ai_about_to_score(rival: CombatObject) -> void:
	about_to_score.emit(rival, %SingleTargetAttackAI)
	%SingleTargetAttackAI.about_to_score_multiplier_SR *= (1 + repeats)
