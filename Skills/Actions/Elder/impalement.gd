@icon("uid://iv1rrfnyxj41")
extends Skill


var impalement_charge : BuildupCharge

func _actor_description(_actor : Actor) -> String:
	var a_description : String = description.replace("<ED-6>", "[color=" + Damage.color_code[Damage.Type.ELDER] + "] "+ str(_actor.potency.value - 6) +" elder damage[/color]")
	if impalement_charge:
		a_description = a_description.replace("5", str(5 + impalement_charge.duration))
	return a_description

func _on_aquired_by_actor():
	combat_object_grandparent.gained_status.connect(_on_gained_status)

func _on_gained_status(_status : StatusEffect):
	if _status is BuildupCharge:
		impalement_charge = _status
	
func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_attack_range(combat_object_grandparent.tile_position)

func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	Globals.over_room_renders.clear_forecast()
	if _in_bounds and Globals.combat_main.tile_occupied(_tile_pos) and %TargetRange.tiles.has(_tile_pos):
		var damage : Damage = Damage.new(actor_parent.potency.value - 6, Damage.Type.ELDER, %Action, actor_parent)
		var line : ForecastLine = ForecastLine.new()
		line.damage_instances.append(damage)
		var blade_count : int = 5
		if impalement_charge:
			blade_count += impalement_charge.duration
		line.repeats = blade_count - 1
		Globals.over_room_renders.action_forecast(_tile_pos, [line])


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if %TargetRange.can_target_position(_tile_pos):
		var target : CombatObject = Globals.combat_main.combat_object_at_tile(_tile_pos)
		var blade_count : int = 5
		if impalement_charge:
			blade_count += impalement_charge.duration
			impalement_charge.queue_free()
		var event = ImpalementEvent.new(combat_object_grandparent, target, Damage.new(actor_parent.potency.value - 6, Damage.Type.ELDER, %Action, actor_parent), blade_count)
		CombatEventManager.add_and_start_combat_event(event)
		%Action.finish()
		
