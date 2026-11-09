@icon("uid://c5m6br7u7iu1m")
extends Skill

const THROW_EVENT := preload("uid://csq1eids7fhpw")
var grabbed_target : CombatObject = null
var skull : Texture2D = preload("uid://dwof3lqxx6nfv")



func _on_action_used(_action: Action) -> void:
	%GrabRange.find_tiles(combat_object_grandparent.tile_position)
	%GrabRange.highlight_tiles()
	%GrabRange.find_targets()
	%GrabRange.targets = %GrabRange.targets.filter(func(combat_object : CombatObject) : return combat_object.weight < actor_parent.might.value)
	%GrabRange.highlight_targets()
	%GrabRange.announce_targets()


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if grabbed_target:
		if %ThrowRange.tiles.has(_tile_pos):
			var grab_event := THROW_EVENT.instantiate()
			grab_event.setup(grabbed_target, combat_object_grandparent, _tile_pos)
			CombatEventManager.add_and_start_combat_event(grab_event)
			%Action.finish()
			grabbed_target = null
	elif %GrabRange.can_target_position(_tile_pos):
		grabbed_target = Globals.combat_main.combat_object_at_tile(_tile_pos)
		%GrabRange.clear_renders()
		%ThrowRange.setup_unoccupied_tile_range(combat_object_grandparent.tile_position)
		Globals.combat_main.give_help_text("Select tile to throw them")


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and grabbed_target and %ThrowRange.tiles.has(_tile_pos):
		var tile_data_type = Globals.combat_main.room.tilemap.get_cell_tile_data(_tile_pos).get_custom_data("Type")
		if tile_data_type == Globals.tile_types.WATER or tile_data_type == Globals.tile_types.CHASM:
			var forecast : ForecastLine = ForecastLine.new()
			forecast.status_icons.append(skull)
			Globals.over_room_renders.create_or_move_action_forecast(_tile_pos, [forecast])
		else:
			Globals.over_room_renders.clear_forecast()
			
	else:
		Globals.over_room_renders.clear_forecast()


func _on_action_inputs_done() -> void:
	grabbed_target = null
