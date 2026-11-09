@icon("uid://c4gs02gns15hf")
extends Skill

const RAIN_STATUS := preload("uid://blbyl72kqwdd6")

func _on_aquired_by_actor():
	%SingleTargetAttackAI.setup(self, %Action, %TargetRange)
	
func rain_on(_tile_pos : Vector2i):
	var target : CombatObject = Globals.combat_main.combat_object_at_tile(_tile_pos)
	var status : StatusEffect = RAIN_STATUS.instantiate()
	target.apply_status_effect_resistable(status, actor_parent.potency.value)
	Globals.over_room_renders.remove_group("AttackRange")
	%Action.finish()

func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_attack_range(combat_object_grandparent.tile_position)


func _on_single_target_attack_ai_ready_to_use_action(_tile_pos: Vector2i) -> void:
	if %TargetRange.can_target_position(_tile_pos):
		rain_on(_tile_pos)
	else:
		%Action.cancel()


func _on_single_target_attack_ai_update_my_damage() -> void:
	%SingleTargetAttackAI.damage = Damage.new(40, Damage.Type.ELECTRIC, %Action, actor_parent)


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if %TargetRange.can_target_position(_tile_pos):
		rain_on(_tile_pos)


func _on_single_target_attack_ai_about_to_score(rival: CombatObject) -> void:
	if rival.has_node("Actor"):
		var actor : Actor = rival.get_node("Actor")
		if actor.resilience.value >= actor_parent.potency.value:
			%SingleTargetAttackAI.about_to_score_multiplier_SR *= 0
		


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)
