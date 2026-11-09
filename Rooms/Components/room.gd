@icon("uid://b8ea6bsk5308d")
class_name Room
extends Node2D

const GRID_TEXTURE := preload("uid://dkulsm48dyiog")

@export var tilemap : TileMapLayer
@export var combat_objects_node : Node2D
@export_multiline() var start_tip : String = ""
@export var next_room_path : String
var grid : Sprite2D

func _ready() -> void:
	grid  = Sprite2D.new()
	grid.texture = GRID_TEXTURE
	grid.position = Vector2(128, 128)
	grid.visible = false
	tilemap.add_sibling(grid)

func toggle_grid():
	grid.visible = not grid.visible

func get_combat_objects() -> Array[CombatObject]:
	var output : Array[CombatObject] = []
	for node : Node in combat_objects_node.get_children():
		if node is PlayerStartPoint:
			var player : CombatObject = PlayerStorage.players[node.slot]
			player.reparent(combat_objects_node)
			output.append(player)
			player.position = node.position
			player.tile_position = Globals.pix_to_tile_pos(player.position)
			player.position_on_tile()
		elif node is CombatObject:
			output.append(node)
			node.position_on_tile()
		else:
			printerr("Children should be either CombatObject or PlayerStartPoint")
	return output
