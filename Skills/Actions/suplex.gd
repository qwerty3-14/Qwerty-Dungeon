@icon("uid://b80s4iu2pbj4f")
extends Skill

const SUPLEX_EVENT := preload("uid://gocnbysw6hkf")
var grabbed_target : CombatObject = null
var skull : Texture2D = preload("uid://dwof3lqxx6nfv")

	
func _on_tile_position_clicked(_tile_pos : Vector2i):
	if grabbed_target:
		if %ThrowRange.tiles.has(_tile_pos):
			var suplex_event := SUPLEX_EVENT.instantiate()
			suplex_event.target = grabbed_target
			suplex_event.attacker = combat_object_grandparent
			suplex_event.drop_location = _tile_pos
			suplex_event.damage = Damage.new(actor_parent.might.value, Damage.Type.CRUSHING, %Action, actor_parent)
			CombatEventManager.add_and_start_combat_event(suplex_event)
			%Action.finish()
			grabbed_target = null
	elif %GrabRange.can_target_position(_tile_pos):
		grabbed_target = Globals.combat_main.combat_object_at_tile(_tile_pos)
		%GrabRange.clear_renders()
		%ThrowRange.setup_unoccupied_tile_range(combat_object_grandparent.tile_position)
		Globals.combat_main.give_help_text("Select tile to drop them")



func _on_action_used(_action: Action) -> void:
	%GrabRange.find_tiles(combat_object_grandparent.tile_position)
	%GrabRange.highlight_tiles()
	%GrabRange.find_targets()
	%GrabRange.targets = %GrabRange.targets.filter(func(combat_object : CombatObject) : return combat_object.weight < actor_parent.might.value)
	%GrabRange.highlight_targets()
	%GrabRange.announce_targets()


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and grabbed_target and %ThrowRange.tiles.has(_tile_pos):
		var forecast : ForecastLine = ForecastLine.new()
		var tile_data_type = Globals.combat_main.room.tilemap.get_cell_tile_data(_tile_pos).get_custom_data("Type")
		if tile_data_type == Globals.tile_types.WATER or tile_data_type == Globals.tile_types.CHASM:
			forecast.status_icons.append(skull)
		else:
			var damage : Damage = Damage.new(actor_parent.might.value, Damage.Type.CRUSHING, %Action, actor_parent)
			damage.modify_against(grabbed_target)
			forecast.damage_instances.append(damage)
		Globals.over_room_renders.create_or_move_action_forecast(_tile_pos, [forecast])
	else:
		Globals.over_room_renders.clear_forecast()


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%GrabRange)


func _on_action_inputs_done() -> void:
	grabbed_target = null
