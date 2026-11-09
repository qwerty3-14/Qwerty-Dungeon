extends Node2D

const SCARLET := preload("uid://cmd7nlwoq1fev")

var players : Array[CombatObject] = []

func _ready() -> void:
	position = Vector2(-100, -100)

func emergency_load():
	players = [CharacterLibrary.packed_scene_dict["Narine"].instantiate(), CharacterLibrary.packed_scene_dict["Bronze"].instantiate(), CharacterLibrary.packed_scene_dict["Sydney"].instantiate(), CharacterLibrary.packed_scene_dict["Scarlet"].instantiate()]
	for player : CombatObject in players:
		player.visible = true
		add_child(player)

func retreive_player(player : CombatObject):
	player.wipe_status_effects()
	player.reparent(self)
	player.position = Vector2.ZERO
	player.get_node("Actor").cur_ap = 0
