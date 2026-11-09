extends Skill


func _on_action_used(_action: Action) -> void:
	pass # Replace with function body.


func _on_action_cursor_moved(_tile_pos: Vector2i, _in_bounds: bool) -> void:
	Globals.over_room_renders.clear_group("BetweenTest")
	if _in_bounds:
		Globals.over_room_renders.highlight_tiles(Globals.tiles_between(combat_object_grandparent.tile_position, _tile_pos), "BetweenTest")
		Globals.over_room_renders.line_arrow(combat_object_grandparent.tile_position, _tile_pos, "BetweenTest")

func _on_action_inputs_done() -> void:
	Globals.over_room_renders.clear_group("BetweenTest")
