@icon("uid://4fip3icu17ec")
extends StatusEffect

var bonus : AttrBonus = AttrBonus.new(-4, "Spellbane Potion")

func _on_ready() -> void:
	if actor:
		actor.potency.add_bonus(bonus)
	description = "Reduces pot by 4"


func _on_tree_exiting() -> void:
	if actor:
		actor.potency.remove_bonus(bonus)
