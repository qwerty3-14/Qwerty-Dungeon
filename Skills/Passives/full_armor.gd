@icon("uid://d2ussx3vm7j81")
extends Skill

var def_bonus : AttrBonus = AttrBonus.new(0, "Full Armor")

func _on_ready():
	combat_object_grandparent.defense.add_bonus(def_bonus)
	Globals.global_singletons_redied.connect(_on_global_singletons_redied_full)

func _on_global_singletons_redied_full():
	%TargetRange.find_tiles(combat_object_grandparent.tile_position)
	def_bonus.set_value(count_targets())
	Globals.global_singletons_redied.disconnect(_on_global_singletons_redied_full)
	
func count_targets() -> int:
	%TargetRange.find_hostile_targets(actor_parent.alignment)
	return %TargetRange.targets.size()

func _on_movement_reciever_object_moved(_tile_pos: Vector2i, _combat_object: CombatObject) -> void:
	if _combat_object == combat_object_grandparent:
		%TargetRange.find_tiles(combat_object_grandparent.tile_position)
		def_bonus.set_value(count_targets())
	if %TargetRange.tiles.has(_tile_pos) or %TargetRange.targets.has(_combat_object):
		def_bonus.set_value(count_targets())
		
