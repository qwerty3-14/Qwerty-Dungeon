@icon("uid://duibkmi1irphu")
extends Skill

const STATUS_ICON : Texture2D = preload("uid://bhirkq3ao7i07")

func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)
	info_panel.load_radius(2.9)


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and %TargetRange.tiles.has(_tile_pos):
		var aoe : Array[Vector2i] = Globals.tiles_in_range(_tile_pos, 2.9, true)
		Globals.over_room_renders.filter_forecast(aoe)
		for tile : Vector2i in aoe:
			if Globals.combat_main.tile_occupied(tile) and not Globals.over_room_renders.has_forecast_at(tile):
				var forecast : ForecastLine = ForecastLine.new()
				forecast.status_icons.append(STATUS_ICON)
				Globals.over_room_renders.action_forecast(tile, [forecast])


func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_tile_range(combat_object_grandparent.tile_position)
	Globals.cursor_manager.set_cursor_aoe(2.9)


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if %TargetRange.tiles.has(_tile_pos):
		var new_event = MiasmaEvent.new(_tile_pos, 2.9, Damage.new(actor_parent.potency.value, Damage.Type.ELDER, %Action, actor_parent))
		CombatEventManager.add_and_start_combat_event(new_event)
		%Action.finish()


func _on_action_inputs_done() -> void:
	Globals.cursor_manager.set_cursor_aoe(0)
