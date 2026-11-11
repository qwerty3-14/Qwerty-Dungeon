extends Node
class_name AStarManager


#redundent from CombatMain
@export var path_drawer : Node2D
@export var actions_menu : Control
#var combat_objects : Array[CombatObject] = []
@export var combat_main : CombatMain

#pathfinding
var friendly_walk_astar : AStarGrid2D = AStarGrid2D.new()
var enemy_walk_astar : AStarGrid2D = AStarGrid2D.new()
var flying_astar : AStarGrid2D = AStarGrid2D.new()
var swimmer_astar : AStarGrid2D = AStarGrid2D.new()
var saved_path : PackedVector2Array = []

func _ready() -> void:
	_astar_defaults(friendly_walk_astar)
	_astar_defaults(enemy_walk_astar)
	_astar_defaults(flying_astar)
	_astar_defaults(swimmer_astar)
	#astar_update_tiles.call_deferred()
	

func generate_move_events(combat_object : CombatObject, path : PackedVector2Array = saved_path) -> Array[CombatEvent]:
	var output : Array[CombatEvent] = []
	while(path.size() > 0):
		var step_event : StepEvent = StepEvent.new(combat_object, path[0])
		add_child(step_event)
		path.remove_at(0)
		output.append(step_event)
	if combat_object.flyer:
		var event : FlyerResetRotation = FlyerResetRotation.new(combat_object)
		add_child(event)
		output.append(event)
	return output

func travel_path(combat_object : CombatObject, path : PackedVector2Array = saved_path):
	Globals.combat_main.set_actor_acted(true)
	CombatEventManager.add_and_start_combat_events(generate_move_events(combat_object, path))


	
func tile_block_friendly(location : Vector2i) -> bool:
	return combat_main.combat_objects.any(func(co : CombatObject): return co.tile_position == location and co.blocks_friendlies)
	
func tile_block_enemies(location : Vector2i) -> bool:
	return combat_main.combat_objects.any(func(co : CombatObject): return co.tile_position == location and co.blocks_enemies)

func _astar_defaults(_astar : AStarGrid2D):
	_astar.region = Rect2i(0, 0, 16, 16)
	_astar.cell_size = Vector2(1, 1)
	_astar.offset = Vector2(0, 0)
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	#_astar.jumping_enabled = true
	_astar.update()
	
func astar_update_tiles():
	for i in range(friendly_walk_astar.region.position.x, friendly_walk_astar.region.end.x):
		for j in range(friendly_walk_astar.region.position.y, friendly_walk_astar.region.end.y):
			var pos = Vector2i(i, j)
			var data : TileData = Globals.combat_main.room.tilemap.get_cell_tile_data(pos)
			Globals.combat_main.room.tilemap.get_cell_atlas_coords(pos)
			if data:
				enemy_walk_astar.set_point_solid(pos, tile_block_enemies(pos))
				friendly_walk_astar.set_point_solid(pos, tile_block_friendly(pos))
				
				if data.get_custom_data("Type") == Globals.tile_types.FLOOR:
					swimmer_astar.set_point_solid(pos)
				if data.get_custom_data("Type") == Globals.tile_types.WALL:
					friendly_walk_astar.set_point_solid(pos)
					enemy_walk_astar.set_point_solid(pos)
					swimmer_astar.set_point_solid(pos)
					flying_astar.set_point_solid(pos)
				if data.get_custom_data("Type") == Globals.tile_types.WATER:
					friendly_walk_astar.set_point_solid(pos)
					enemy_walk_astar.set_point_solid(pos)
				if data.get_custom_data("Type") == Globals.tile_types.CHASM:
					friendly_walk_astar.set_point_solid(pos)
					enemy_walk_astar.set_point_solid(pos)
					swimmer_astar.set_point_solid(pos)

func grid_to_use(combatObject : CombatObject) -> AStarGrid2D:
	if combatObject.flyer:
		return flying_astar
	if combatObject.blocks_friendlies:
		return enemy_walk_astar
	if combatObject.blocks_enemies:
		return friendly_walk_astar
	return flying_astar

func find_path_for_combat_object(move_me : CombatObject, destination : Vector2i, max_length : int = -1) -> PackedVector2Array:
	var astar_grid : AStarGrid2D = grid_to_use(move_me)
	var path : PackedVector2Array = astar_grid.get_point_path(move_me.tile_position, destination)
	if path.size() > 0:
		path.remove_at(0)
	if path.size() > 0:
		if max_length != -1 and path.size() > max_length:
			path.resize(max_length)
		while(path.size() > 0 and Globals.combat_main.tile_occupied(path[-1])):
			path.remove_at(path.size() - 1)
		return path
	return []

func standable_tiles_for_combat_object(co : CombatObject, tiles : Array[Vector2i]) -> Array[Vector2i]:
	var astar_grid : AStarGrid2D = grid_to_use(co)
	#print("Pre Filter: " + str(tiles))
	#print("Post Filter: " + str(tiles.filter(func(tile : Vector2i): return (not Globals.combat_main.tile_occupied(tile)) and (not astar_grid.is_point_solid(tile)))))
	return tiles.filter(func(tile : Vector2i): return (not Globals.combat_main.tile_occupied(tile)) and (not astar_grid.is_point_solid(tile)))

func calculate_path_for_actor(move_me : CombatObject, actor : Actor, _position: Vector2i, _in_bounds: bool):
	if _in_bounds and not combat_main.tile_occupied(_position):
		var path : PackedVector2Array = find_path_for_combat_object(move_me, _position, actor.cur_mp + actor.cur_ap)
		if path.size() > 0:
			saved_path = path
			actions_menu.set_move_cost(min(actor.cur_mp, path.size()))
			if path.size() > actor.cur_mp:
				actions_menu.set_ap_cost(path.size() - actor.cur_mp)
			else:
				actions_menu.set_ap_cost(0)
			path_drawer.path = saved_path
			path_drawer.start_loc = move_me.tile_position
			path_drawer.mp = actor.cur_mp
			path_drawer.can_draw = true
			path_drawer.queue_redraw()
		else:
			empty_path()
	else:
		empty_path()

func tiles_in_reach(co : CombatObject, max_length : int) -> Array[Vector2i]:
	var output_array : Array[Vector2i] = []
	var center : Vector2i = co.tile_position
	var start_x : int  = floori(center.x - max_length)
	var end_x : int  = ceili(center.x + max_length)
	for i in range(start_x, end_x + 1):
		var x_dist : int = abs(i - center.x)
		var start_y : int  = floori(center.y - (max_length - x_dist))
		var end_y : int  = ceili(center.y + (max_length - x_dist))
		for j in range(start_y, end_y + 1):
			var tile : Vector2i = Vector2i(i, j)
			if Globals.tile_pos_in_bounds(tile):
				var path_length = find_path_for_combat_object(co, tile).size()
				if center == tile or (path_length <= max_length and path_length > 0):
					output_array.append(tile)
	return output_array


func empty_path():
	path_drawer.mp = 0
	path_drawer.can_draw = false
	path_drawer.queue_redraw()
	saved_path = []
	actions_menu.set_move_cost(0)
	actions_menu.set_ap_cost(0)
