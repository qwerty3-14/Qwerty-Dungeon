@icon("uid://db31ox8py3af0")
extends Skill


func _actor_description(_actor : Actor) -> String:
	var a_description : String = description.replace("<FD>", "[color=" + Damage.color_code[Damage.Type.FIRE] + "] "+ str(_actor.potency.value * 3) +" fire damage[/color]")
	return a_description


func _on_tile_position_clicked(_tile_pos : Vector2i):
	if %TargetRange.tiles.has(_tile_pos):
		var ball_event = FireballEvent.new(combat_object_grandparent, _tile_pos, Damage.new(actor_parent.potency.value * 3, Damage.Type.FIRE, %Action, actor_parent))
		
		CombatEventManager.add_and_start_combat_event(ball_event)
		%Action.finish()


func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_tile_range(combat_object_grandparent.tile_position)
	Globals.cursor_manager.set_cursor_aoe(1.5)


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and %TargetRange.tiles.has(_tile_pos):
		var aoe : Array[Vector2i] = Globals.tiles_in_range(_tile_pos, 1.5, true)
		Globals.over_room_renders.filter_forecast(aoe)
		for tile : Vector2i in aoe:
			if Globals.combat_main.tile_occupied(tile) and not Globals.over_room_renders.has_forecast_at(tile):
				var co : CombatObject = Globals.combat_main.combat_object_at_tile(tile)
				var damage : Damage = Damage.new(actor_parent.potency.value * 3, Damage.Type.FIRE, %Action, actor_parent)
				damage.modify_against(co)
				var forecast : ForecastLine = ForecastLine.new()
				forecast.damage_instances.append(damage)
				Globals.over_room_renders.action_forecast(tile, [forecast])


func _on_action_inputs_done() -> void:
	Globals.cursor_manager.set_cursor_aoe(0)


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)
	info_panel.load_radius(1.5)
