@icon("uid://cir76a8kw5gmb")
extends Skill


var extra_tiles : Array[Vector2i] = []
var aoe : Array[Vector2i] = []
var direction : float = 0

func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_tile_range(combat_object_grandparent.tile_position)


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds and %TargetRange.tiles.has(_tile_pos):
		extra_tiles.clear()
		var diff : Vector2i = _tile_pos - combat_object_grandparent.tile_position
		match diff:
			Vector2i.RIGHT:
				for i in range(-1, 2):
					extra_tiles.append(Vector2i(2, i) + combat_object_grandparent.tile_position)
				for i in range(-2, 3):
					extra_tiles.append(Vector2i(3, i) + combat_object_grandparent.tile_position)
				direction = 0
			Vector2i.LEFT:
				for i in range(-1, 2):
					extra_tiles.append(Vector2i(-2, i) + combat_object_grandparent.tile_position)
				for i in range(-2, 3):
					extra_tiles.append(Vector2i(-3, i) + combat_object_grandparent.tile_position)
				direction = PI
			Vector2i.UP:
				for i in range(-1, 2):
					extra_tiles.append(Vector2i(i, -2) + combat_object_grandparent.tile_position)
				for i in range(-2, 3):
					extra_tiles.append(Vector2i(i, -3) + combat_object_grandparent.tile_position)
				direction = PI * -0.5
			Vector2i.DOWN:
				for i in range(-1, 2):
					extra_tiles.append(Vector2i(i, 2) + combat_object_grandparent.tile_position)
				for i in range(-2, 3):
					extra_tiles.append(Vector2i(i, 3) + combat_object_grandparent.tile_position)
				direction = PI * 0.5
			_:
				extra_tiles.append(diff * 2 + combat_object_grandparent.tile_position)
				extra_tiles.append(Vector2i(diff.x * 2, diff.y) + combat_object_grandparent.tile_position)
				extra_tiles.append(Vector2i(diff.x, diff.y * 2) + combat_object_grandparent.tile_position)
				extra_tiles.append(Vector2i(diff.x * 3, diff.y) + combat_object_grandparent.tile_position)
				extra_tiles.append(Vector2i(diff.x, diff.y * 3) + combat_object_grandparent.tile_position)
				direction = atan2(diff.y, diff.x)
				
		
		extra_tiles = extra_tiles.filter(func(tile : Vector2i): return Globals.tile_pos_in_bounds(tile))
		Globals.cursor_manager.set_cursor_extra_tiles(extra_tiles)
		aoe = [diff + combat_object_grandparent.tile_position]
		aoe.append_array(extra_tiles)
		Globals.over_room_renders.filter_forecast(aoe)
		for tile : Vector2i in aoe:
			if Globals.combat_main.tile_occupied(tile) and not Globals.over_room_renders.has_forecast_at(tile):
				var co : CombatObject = Globals.combat_main.combat_object_at_tile(tile)
				var damage : Damage = Damage.new(actor_parent.potency.value, Damage.Type.FIRE, %Action, actor_parent)
				damage.modify_against(co)
				var forecast : ForecastLine = ForecastLine.new()
				forecast.damage_instances.append(damage)
				Globals.over_room_renders.action_forecast(tile, [forecast])
	else:
		Globals.cursor_manager.set_cursor_extra_tiles([])
		Globals.over_room_renders.clear_forecast()


func _on_action_inputs_done() -> void:
	Globals.cursor_manager.set_cursor_extra_tiles([])
	Globals.over_room_renders.clear_forecast()


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.set_range(1.5)
	info_panel.load_radius(1.5)


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if %TargetRange.tiles.has(_tile_pos):
		var damage : Damage = Damage.new(actor_parent.potency.value, Damage.Type.FIRE, %Action, actor_parent)
		var event = ConeOfFireEvent.new(damage, direction, combat_object_grandparent.tile_position, aoe)
		CombatEventManager.add_and_start_combat_event(event)
		%Action.finish()
	else:
		%Action.cancel()
