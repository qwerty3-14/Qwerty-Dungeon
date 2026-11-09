extends Node

signal global_singletons_redied()

const TILE_SIDE : int = 16
const TILE_SIZE : Vector2i = Vector2i(TILE_SIDE, TILE_SIDE)
const STANDARD_LONG_RANGE : float = 8

enum tile_types  {FLOOR, WALL, CHASM, WATER, DEBRIS}
#enum damage_type {
#	DIRECT, ##ignores defense and resistance
#	CRUSHING, ##physical damage
#	PIERCING, ##physical damage
#	SLASHING, ##physical damage
#	FIRE, ##magical damage
#	ELDER, ##magical damage
#	POISON ##magical damage
#	}
enum alignment {
	PLAYABLE, ##player controled characters
	EVIL, ##Most enemies, attack any Non EVIL actors
	BEAST, ##Wild beasts
}

var elapsed_time = 0

var combat_main : CombatMain
var a_star_manager : AStarManager
var cursor_manager : CursorManager
var over_room_renders : OverRoomRenders
var actions_menu : ActionsMenu
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var effect_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var finished_singletons_setup : bool = false

func pix_to_tile_pos(position : Vector2) -> Vector2i:
	var divided : Vector2 = (position) * (1/float(TILE_SIDE))
	divided.x = floori(divided.x)
	divided.y = floori(divided.y)
	return Vector2i(divided)

func tile_to_pix_pos(tile_position : Vector2i) -> Vector2:
	return Vector2(tile_position) * TILE_SIDE + TILE_SIZE * 0.5

func tile_pos_in_bounds(tile_position : Vector2i) -> bool:
	return tile_position.x >= 0 and tile_position.x < 16 and tile_position.y >= 0 and tile_position.y < 16

func tiles_in_range(center : Vector2i, selection_range : float, include_self : bool = false, minimum_range : float = 0) -> Array[Vector2i]:
	var output : Array[Vector2i] = []
	var start_x : int  = floori(center.x - selection_range)
	var end_x : int  = ceili(center.x + selection_range)
	var start_y : int  = floori(center.y - selection_range)
	var end_y : int  = ceili(center.y + selection_range)
	for i in range(start_x, end_x + 1):
		for j in range(start_y, end_y + 1):
			var tile : Vector2i =  Vector2i(i, j)
			if include_self or tile != center:
				var distance : float = (Vector2(tile) - Vector2(center)).length()
				if tile_pos_in_bounds(tile) and distance <= selection_range and distance >= minimum_range:
					output.append(tile)
	return output

func los_tiles_in_range(center : Vector2i, selection_range : float, include_self : bool = false, minimum_range : float = 0, los_block_tiles : Array[tile_types] = [tile_types.WALL], end_block_tiles : Array[tile_types] = [tile_types.WALL, tile_types.DEBRIS]) -> Array[Vector2i]:
	var output : Array[Vector2i] = []
	var tiles_within_range : Array[Vector2i] = tiles_in_range(center, selection_range, include_self, minimum_range)
	for tile : Vector2i in tiles_within_range:
		var data : TileData = Globals.combat_main.room.tilemap.get_cell_tile_data(tile)
		if not end_block_tiles.has(data.get_custom_data("Type")):
			var between_tiles : Array[Vector2i] = tiles_between(center, tile)
			if not between_tiles.any(func(b_t : Vector2i) : return los_block_tiles.has(Globals.combat_main.room.tilemap.get_cell_tile_data(b_t).get_custom_data("Type"))):
				output.append(tile)
	return output

func tiles_between(start : Vector2i, end : Vector2i) -> Array[Vector2i]:
	var output : Array[Vector2i] = []
	var x_range = range(min(start.x, end.x), max(start.x, end.x) + 1)
	var y_range = range(min(start.y, end.y), max(start.y, end.y) + 1)
	if x_range.size() == 1: #vertical line
		for x : int in x_range:
			for y : int in y_range:
				var tile : Vector2i = Vector2i(x, y)
				if tile != start and tile != end:
					output.append(tile)
	else:
		var slope : float = float(end.y - start.y) / float(end.x - start.x)
		var y_intercept : float = start.y - float(slope * start.x)
		#print("Tiles Between:")
		for x : int in x_range:
			for y : int in y_range:
				var tile : Vector2i = Vector2i(x, y)
				if tile != start and tile != end:
					var left_of_tile : float = float(tile.x) - 0.5
					var right_of_tile : float = float(tile.x) + 0.5
					var y_at_left = slope * left_of_tile + y_intercept
					var y_at_right = slope * right_of_tile + y_intercept
					if abs(y_at_left - tile.y) < 0.49 or abs(y_at_right - tile.y) < 0.49 or sign(y_at_left - tile.y) != sign(y_at_right - tile.y):
						output.append(tile)
						#print("TileY: " + str(tile.y) + ", LeftY: " + str(y_at_left) + ", RightY: " + str(y_at_right) + ", YES")
						#print("TileY: " + str(tile.y) + ", LeftDiff: " + str(abs(y_at_left - tile.y)) + ", RightDiff: " + str(abs(y_at_right - tile.y)) + ", YES")
						#print("TileY: " + str(tile.y) + ", sign flipped: " + str(sign(y_at_left - tile.y) != sign(y_at_right - tile.y)) + ", YES")
					#else:
						#print("TileY: " + str(tile.y) + ", sign flipped: " + str(sign(y_at_left - tile.y) != sign(y_at_right - tile.y)) + ", NO")
						#print("TileY: " + str(tile.y) + ", LeftY: " + str(y_at_left) + ", RightY: " + str(y_at_right) + ", NO")
						#print("TileY: " + str(tile.y) + ", LeftDiff: " + str(abs(y_at_left - tile.y)) + ", RightDiff: " + str(abs(y_at_right - tile.y)) + ", YES")
	return output

func closest_tile(from : Vector2i, tiles : Array[Vector2i]) -> Vector2i:
	var closest_square_dist = -1
	var closest_tile_output = Vector2.ZERO
	for tile : Vector2i in tiles:
		if closest_square_dist == -1 or (tile - from).length_squared() <  closest_square_dist:
			closest_square_dist = (tile - from).length_squared()
			closest_tile_output = tile
	return closest_tile_output

func _process(delta: float) -> void:
	elapsed_time += delta
	if Input.is_action_just_released("ToggleFullscreen"):
		if get_window().mode == Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_FULLSCREEN


func send_singletons_ready_signal():
	finished_singletons_setup = true
	global_singletons_redied.emit()
