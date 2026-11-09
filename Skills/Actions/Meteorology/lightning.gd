@icon("uid://cunn36mfskcl6")
extends Skill


func _on_aquired_by_actor():
	%SingleTargetAttackAI.setup(self, %Action, %TargetRange)

func shoot_at(_tile_pos : Vector2i):
	var _target : CombatObject = Globals.combat_main.combat_object_at_tile(_tile_pos)
	var lightning_event = LightningEvent.new(combat_object_grandparent, _target, Damage.new(actor_parent.potency.value, Damage.Type.ELECTRIC, %Action, actor_parent))
	CombatEventManager.add_and_start_combat_event(lightning_event)
	Globals.over_room_renders.remove_group("AttackRange")
	%Action.finish()


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if %TargetRange.can_target_position(_tile_pos):
		shoot_at(_tile_pos)


func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_attack_range(combat_object_grandparent.tile_position)


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and %TargetRange.can_target_position(_tile_pos):
		var _target : CombatObject = Globals.combat_main.combat_object_at_tile(_tile_pos)
		var damage : Damage = Damage.new(actor_parent.potency.value, Damage.Type.ELECTRIC, %Action, actor_parent)
		damage.modify_against(_target)
		var forecast : ForecastLine = ForecastLine.new()
		forecast.damage_instances.append(damage)
		Globals.over_room_renders.create_or_move_action_forecast(_tile_pos, [forecast])
	else:
		Globals.over_room_renders.clear_forecast()


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)


func _on_single_target_attack_ai_ready_to_use_action(_tile_pos: Vector2i) -> void:
	if %TargetRange.can_target_position(_tile_pos):
		shoot_at(_tile_pos)
	else:
		%Action.cancel()


func _on_single_target_attack_ai_update_my_damage() -> void:
	%SingleTargetAttackAI.damage = Damage.new(actor_parent.potency.value, Damage.Type.ELECTRIC, %Action, actor_parent)
