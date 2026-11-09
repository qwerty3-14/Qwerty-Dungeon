@icon("uid://dqb2wrnm40a7m")
extends Skill


var shadow_stab : bool = false

func get_damage(target : CombatObject) -> Damage:
	var out_damage : Damage = Damage.new(actor_parent.potency.value, Damage.Type.ELDER, %Action, actor_parent)
	out_damage.modify_against(target)
	if target.health.current >= target.health.maximum:
		out_damage.amount *= 2
	if shadow_stab and out_damage.amount * 2 >= target.health.current:
		out_damage.amount *= 2
	return out_damage

func _actor_description(_actor : Actor) -> String:
	if shadow_stab:
		var a_description : String = "Deals [color=" + Damage.color_code[Damage.Type.ELDER] + "] "+ str(_actor.potency.value) +" elder damage[/color]"
		a_description += "[p]Damage is doubled if target is at full health.[/p][p]Damage is doubled if it leads to a kill.[/p]"
		a_description += "[p][/p]"
		a_description += "[p]{DP}[/p]"
		return a_description
	return super._actor_description(_actor)

func _on_tile_position_clicked(_tile_pos : Vector2i):
	if %TargetRange.can_target_position(_tile_pos):
		var _target : CombatObject = Globals.combat_main.combat_object_at_tile(_tile_pos)
		var damage : Damage = get_damage(_target)
		var strike_event = ShadowStrikeEvent.new(_target, damage)
		CombatEventManager.add_and_start_combat_event(strike_event)
		Globals.over_room_renders.remove_group("AttackRange")
		%Action.finish()

func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_attack_range(combat_object_grandparent.tile_position)


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and %TargetRange.can_target_position(_tile_pos):
		var _target : CombatObject = Globals.combat_main.combat_object_at_tile(_tile_pos)
		var forecast : ForecastLine = ForecastLine.new()
		forecast.damage_instances.append(get_damage(_target))
		Globals.over_room_renders.create_or_move_action_forecast(_tile_pos, [forecast])
	else:
		Globals.over_room_renders.clear_forecast()


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)
