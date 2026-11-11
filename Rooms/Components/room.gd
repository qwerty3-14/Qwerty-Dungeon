@icon("uid://b8ea6bsk5308d")
class_name Room
extends Node2D

const GRID_TEXTURE := preload("uid://dkulsm48dyiog")

@export var tilemap : TileMapLayer
@export var combat_objects_node : Node2D
@export_multiline() var start_tip : String = ""
@export var next_room_path : String
var grid : Sprite2D
var below_combat_objects : Node2D
var reinforcements : Dictionary[int, Array] 

func _ready() -> void:
	grid  = Sprite2D.new()
	grid.texture = GRID_TEXTURE
	grid.position = Vector2(128, 128)
	grid.visible = false
	tilemap.add_sibling(grid)
	below_combat_objects = Node2D.new()
	get_child(combat_objects_node.get_index() - 1).add_sibling(below_combat_objects)
	below_combat_objects.name = "BelowCombatObjects"

func toggle_grid():
	grid.visible = not grid.visible

func get_combat_objects() -> Array[CombatObject]:
	Globals.combat_main.pre_phase_starting.connect(_on_phase_starting)
	var output : Array[CombatObject] = []
	for node : Node in combat_objects_node.get_children():
		if node is PlayerStartPoint:
			var player : CombatObject = PlayerStorage.players[node.slot]
			player.reparent(combat_objects_node)
			output.append(player)
			player.position = node.position
			player.tile_position = Globals.pix_to_tile_pos(player.position)
			player.position_on_tile()
		elif node is ReinforcementSpawn:
			var reinforcement : ReinforcementSpawn = node
			if not reinforcements.has(reinforcement.phase_arriving):
				reinforcements[reinforcement.phase_arriving] = []
			reinforcements[reinforcement.phase_arriving].append(reinforcement)
		elif node is CombatObject:
			output.append(node)
			node.position_on_tile()
		else:
			printerr("Children should be either CombatObject, ReinforcementSpawn, or PlayerStartPoint")
	return output

func _on_phase_starting():
	Globals.over_room_renders.clear_below_combat_opbjects_renders()
	if reinforcements.has(Globals.combat_main.current_phase):
		for reinforcemnt : ReinforcementSpawn in reinforcements[Globals.combat_main.current_phase]:
			var co : CombatObject = reinforcemnt.packed_combat_object.instantiate()
			combat_objects_node.add_child(co)
			var tile_pos : Vector2i = Globals.pix_to_tile_pos(reinforcemnt.position)
			var offset : Vector2i = Vector2i.ZERO
			if tile_pos.x == 15:
				offset = Vector2i.RIGHT
			elif tile_pos.x == 0:
				offset = Vector2i.LEFT
			elif tile_pos.y == 15:
				offset = Vector2i.DOWN
			elif tile_pos.y == 0:
				offset = Vector2i.UP
			if offset == Vector2i.ZERO:
				co.tile_position = tile_pos
				co.position_on_tile()
				Globals.combat_main.add_combat_object_during_combat(co)
			else:
				co.tile_position = tile_pos + offset
				co.position_on_tile()
				Globals.combat_main.add_combat_object_during_combat(co)
				CombatEventManager.add_and_start_combat_event(StepEvent.new(co, tile_pos))
				if co.flyer:
					CombatEventManager.add_and_start_combat_event(FlyerResetRotation.new(co))
	if reinforcements.has(Globals.combat_main.current_phase + 1):
		for reinforcemnt : ReinforcementSpawn in reinforcements[Globals.combat_main.current_phase + 1]:
			Globals.over_room_renders.warn_tile(Globals.pix_to_tile_pos(reinforcemnt.position))
