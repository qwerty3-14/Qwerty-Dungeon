@icon("uid://cps1f8hniijaj")
extends Skill

var target_range : TargetRange


func _on_aquired_by_actor():
	target_range = %ModifiedWeaponAttack.target_range
	target_range.find_tiles(combat_object_grandparent.tile_position)
	%ModifiedWeaponAttack.weapon_attack_updated.connect(_on_weapon_attack_updated)
	MetaCombat.combat_started.connect(_on_combat_started)

func _on_weapon_attack_updated():
	target_range = %ModifiedWeaponAttack.target_range
	target_range.find_tiles(combat_object_grandparent.tile_position)

func _on_combat_started():
	target_range = %ModifiedWeaponAttack.target_range
	target_range.find_tiles(combat_object_grandparent.tile_position)

func _on_movement_reciever_object_moved(_tile_pos: Vector2i, _combat_object: CombatObject) -> void:
	#print(_combat_object.name + ": " + str(_tile_pos))
	if actor_parent:
		if _combat_object == combat_object_grandparent:
			target_range.find_tiles(_tile_pos)
		elif _combat_object.has_node("Actor"):
			var actor : Actor = _combat_object.get_node("Actor")
			if actor.alignment != actor_parent.alignment:
				target_range.find_targets()
				if target_range.targets.has(_combat_object) and actor_parent.cur_ap >= %Reaction.ap_cost:
					if %ModifiedWeaponAttack.try_to_attack_position(_tile_pos, true):
						%Reaction.spend_ap()
