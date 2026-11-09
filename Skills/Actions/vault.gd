@icon("uid://cvy6xw20eg7uo")
extends Skill


const VAULT_EVENT = preload("uid://bt1ur71cwvntb")

func _on_action_used(_action: Action) -> void:
	%TargetRange.setup_unoccupied_tile_range(combat_object_grandparent.tile_position)
	Globals.combat_main.give_help_text("Select tile to leap to!")


func _on_action_tile_position_clicked(_tile_pos: Vector2i) -> void:
	if %TargetRange.tiles.has(_tile_pos):
		var event := VAULT_EVENT.instantiate()
		event.jumper = combat_object_grandparent
		event.landing_loc = _tile_pos
		event.wait_time = (_tile_pos - combat_object_grandparent.tile_position).length() * 0.25
		CombatEventManager.add_and_start_combat_event(event)
		%TargetRange.clear_renders()
		%Action.finish()


func _on_need_info_panel_extras(info_panel: InfoPanel) -> void:
	info_panel.load_range(%TargetRange)
