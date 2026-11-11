extends Node
class_name TargetRange


@export var attack_range : float = 1
@export var min_range : float = 0
@export var include_self : bool = false
@export var group_name : String = "AttackRange"
@export var action : Action
@export var effected_by_blindness : bool = true

@export var los_block_tiles : Array[Globals.tile_types] = [Globals.tile_types.WALL]
@export var end_block_tiles : Array[Globals.tile_types] = [Globals.tile_types.WALL, Globals.tile_types.DEBRIS]

var tiles : Array[Vector2i] = []
var targets : Array[CombatObject] = []
var blindable_actor : Actor

func _ready() -> void:
	if action:
		action.inputs_done.connect(clear_renders)


func setup_attack_range(tile_pos : Vector2i):
	find_tiles(tile_pos)
	highlight_tiles()
	find_targets()
	highlight_targets()
	announce_targets()

func setup_tile_range(tile_pos : Vector2i):
	find_tiles(tile_pos)
	highlight_tiles()
	announce_tiles()

func setup_unoccupied_tile_range(tile_pos : Vector2i):
	find_tiles(tile_pos)
	remove_occupied()
	highlight_tiles()

func remove_occupied():
	find_targets()
	tiles = tiles.filter(func(tile : Vector2i) : return not targets.any(func(target : CombatObject) : return target.tile_position == tile))

func find_tiles(tile_pos : Vector2i):
	if blindable_actor and blindable_actor.blinded:
		tiles = Globals.los_tiles_in_range(tile_pos, 1, include_self, 0, los_block_tiles, end_block_tiles)
	else:
		tiles = Globals.los_tiles_in_range(tile_pos, attack_range, include_self, min_range, los_block_tiles, end_block_tiles)

func highlight_tiles():
	Globals.over_room_renders.highlight_tiles(tiles, group_name)

func find_targets():
	targets.clear()
	for tile : Vector2i in tiles:
		if Globals.combat_main.tile_occupied(tile):
			targets.append(Globals.combat_main.combat_object_at_tile(tile))

func find_hostile_targets(my_alignment : Globals.alignment):
	find_targets()
	targets = targets.filter(func(target : CombatObject): return target.has_node("Actor") and target.get_node("Actor").alignment != my_alignment)

func highlight_targets():
	targets.map(func(target : CombatObject) : Globals.over_room_renders.higlight_object(target.tile_position, group_name))

func announce_targets():
	if targets.size() > 0:
		Globals.combat_main.give_help_text("Select target")
	else:
		Globals.combat_main.give_help_text("No Valid Targets")
		
func announce_tiles():
	if tiles.size() > 0:
		Globals.combat_main.give_help_text("Select tile")
	else:
		Globals.combat_main.give_help_text("No Valid Tiles")

func clear_renders():
	Globals.over_room_renders.remove_group(group_name)


func can_target_position(_tile_pos : Vector2i) -> bool:
	return Globals.combat_main.tile_occupied(_tile_pos) and targets.has(Globals.combat_main.combat_object_at_tile(_tile_pos))
