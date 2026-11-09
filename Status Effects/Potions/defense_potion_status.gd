@icon("uid://sj428kk1a5tw")
extends StatusEffect

var bonus_def : AttrBonus = AttrBonus.new(4, "Defense Potion")

func _on_ready() -> void:
	parent.defense.add_bonus(bonus_def)
	description = "Grants 4 defense"



func _on_tree_exiting() -> void:
	parent.defense.remove_bonus(bonus_def)
