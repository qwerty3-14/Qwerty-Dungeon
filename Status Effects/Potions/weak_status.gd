@icon("uid://b8e8pcfd7he")
extends StatusEffect

var bonus : AttrBonus = AttrBonus.new(-4, "Weak Potion")

func _on_ready() -> void:
	if actor:
		actor.might.add_bonus(bonus)
	description = "Reduces mgt by 4"


func _on_tree_exiting() -> void:
	if actor:
		actor.might.remove_bonus(bonus)
