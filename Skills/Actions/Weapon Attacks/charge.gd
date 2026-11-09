@icon("uid://d3gqcav53t14f")
extends Skill


var charge_locs : Dictionary[CombatObject, Vector2i]
@onready var target_range : TargetRange = %TargetRange


func _on_action_used(_action: Action) -> void:
	var center : Vector2i = combat_object_grandparent.tile_position
	var weapon_range : float = actor_parent.default_weapon_attack.target_range.attack_range
	%WeaponAttackDamage.damage_type = actor_parent.default_weapon_attack.damage_type
	target_range.find_tiles(center)
	target_range.find_targets()
	charge_locs.clear()
	var valid_targets : Array[CombatObject] = []
	for target : CombatObject in target_range.targets:
		var tiles_between : Array[Vector2i] = Globals.tiles_between(center, target.tile_position)
		tiles_between.sort_custom(func(before_tile : Vector2i, other_tile : Vector2i): return (before_tile - center).length_squared() < (other_tile - center).length_squared())
		for tile : Vector2i in tiles_between:
			if Globals.a_star_manager.friendly_walk_astar.is_point_solid(tile):
				break
			elif (target.tile_position - tile).length() <= weapon_range and not Globals.combat_main.tile_occupied(tile):
				valid_targets.append(target)
				charge_locs[target] = tile
				break
	target_range.targets = valid_targets
	target_range.highlight_tiles()
	target_range.highlight_targets()
	#print(charge_locs)
	#print(target_range.targets)


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if target_range.can_target_position(_tile_pos):
		var wae := ChargeAttackEvent.new(combat_object_grandparent, 
			Globals.combat_main.combat_object_at_tile(_tile_pos), 
			Damage.new(actor_parent.might.value, actor_parent.default_weapon_attack.damage_type, %Action, actor_parent),
			charge_locs[Globals.combat_main.combat_object_at_tile(_tile_pos)])
		CombatEventManager.add_and_start_combat_event(wae)
		%Action.finish()


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	Globals.over_room_renders.clear_group("ChargeLine")
	if target_range.can_target_position(_tile_pos):
		var charge_pos : Vector2i = charge_locs[Globals.combat_main.combat_object_at_tile(_tile_pos)]
		Globals.over_room_renders.line_arrow(combat_object_grandparent.tile_position, charge_pos, "ChargeLine")
		
	if _in_bounds and target_range.can_target_position(_tile_pos):
		%WeaponAttackDamage.create_forecast(Globals.combat_main.combat_object_at_tile(_tile_pos))
	else:
		Globals.over_room_renders.clear_forecast()


func _on_action_inputs_done() -> void:
	Globals.over_room_renders.remove_group("ChargeLine")


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)
