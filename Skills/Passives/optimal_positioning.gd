@icon("uid://y261f110mw7c")
extends Skill

var damage_bonus : AttrBonus = AttrBonus.new(3, "Optimal Positioning")
var giving_bonus : bool = false
var previus_bonus : bool = false


func _on_aquired_by_actor():
	%TargetRange.find_tiles(combat_object_grandparent.tile_position)
	%TargetRange.find_targets()
	toggle_bonus()

func _on_movement_reciever_object_moved(_tile_pos: Vector2i, _combat_object: CombatObject) -> void:
	if actor_parent:
		if _combat_object == combat_object_grandparent:
			%TargetRange.find_tiles(_tile_pos)
		%TargetRange.find_targets()
		toggle_bonus()

func toggle_bonus():
	giving_bonus = %TargetRange.targets.size() <= 0
	if giving_bonus != previus_bonus:
		if giving_bonus:
			actor_parent.might.add_bonus(damage_bonus)
		else:
			actor_parent.might.remove_bonus(damage_bonus)
	previus_bonus = giving_bonus
