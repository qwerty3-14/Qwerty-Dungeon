extends Node

enum all_runes {
	TINY_MGT_RUNE,
	SMALL_MGT_RUNE,
	MED_MGT_RUNE,
	ALL_MGT_RUNE,
	LARGE_MGT_RUNE,
	TINY_POT_RUNE,
	SMALL_POT_RUNE,
	MED_POT_RUNE,
	ALL_POT_RUNE,
	LARGE_POT_RUNE,
	TINY_CON_RUNE,
	SMALL_CON_RUNE,
	MED_CON_RUNE,
	ALL_CON_RUNE,
	LARGE_CON_RUNE,
	TINY_RES_RUNE,
	SMALL_RES_RUNE,
	MED_RES_RUNE,
	ALL_RES_RUNE,
	LARGE_RES_RUNE,
	TINY_INT_RUNE,
	SMALL_INT_RUNE,
	MED_INT_RUNE,
	ALL_INT_RUNE,
	LARGE_INT_RUNE,
	TINY_SPD_RUNE,
	SMALL_SPD_RUNE,
	MED_SPD_RUNE,
	ALL_SPD_RUNE,
	LARGE_SPD_RUNE,
	TINY_LCK_RUNE,
	SMALL_LCK_RUNE,
	MED_LCK_RUNE,
	ALL_LCK_RUNE,
	LARGE_LCK_RUNE
}

var rune_info_dict : Dictionary[all_runes, RuneInfo] = {
	all_runes.TINY_MGT_RUNE : RuneInfo.new("Tiny Might Rune", Vector2i(0, 4), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)]),
	all_runes.SMALL_MGT_RUNE : RuneInfo.new("Small Might Rune", Vector2i(1, 4), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, 1), Vector2i(-1, 1)]),
	all_runes.MED_MGT_RUNE : RuneInfo.new("Medium Might Rune", Vector2i(2, 4), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1),  Vector2i(2, -1), Vector2i(2, -2), Vector2i(0, 1), Vector2i(-1, 1)]),
	all_runes.ALL_MGT_RUNE : RuneInfo.new("All Might Rune", Vector2i(3, 4), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1),  Vector2i(2, -1), Vector2i(2, -2), Vector2i(0, 1), Vector2i(-1, 1), Vector2i(-1, 2)]),
	all_runes.LARGE_MGT_RUNE : RuneInfo.new("Large Might Rune", Vector2i(4, 4), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1),  Vector2i(2, -1), Vector2i(2, -2), Vector2i(0, 1), Vector2i(-1, 1), Vector2i(-1, 2), Vector2i(-2, 2)]),
	all_runes.TINY_POT_RUNE : RuneInfo.new("Tiny Potency Rune", Vector2i(0, 6), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, -1)]),
	all_runes.SMALL_POT_RUNE : RuneInfo.new("Small Potency Rune", Vector2i(1, 6), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]),
	all_runes.MED_POT_RUNE : RuneInfo.new("Medium Potency Rune", Vector2i(2, 6), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(-2, 0), Vector2i(0, 1), Vector2i(0, -1)]),
	all_runes.ALL_POT_RUNE : RuneInfo.new("All Potency Rune", Vector2i(3, 6), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(1, -1), Vector2i(-1, 0), Vector2i(1, 1), Vector2i(0, -2), Vector2i(2, -1)]),
	all_runes.LARGE_POT_RUNE : RuneInfo.new("Large Potency Rune", Vector2i(4, 6), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(-2, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, -1), Vector2i(0, -2)]),
	all_runes.TINY_CON_RUNE : RuneInfo.new("Tiny Constitution Rune", Vector2i(0, 3), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0)]),
	all_runes.SMALL_CON_RUNE : RuneInfo.new("Small Constitution Rune", Vector2i(1, 3), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(-2, 0)]),
	all_runes.MED_CON_RUNE : RuneInfo.new("Medium Constitution Rune", Vector2i(2, 3), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(-1, 0), Vector2i(-2, 0), Vector2i(-3, 0)]),
	all_runes.ALL_CON_RUNE : RuneInfo.new("All Constitution Rune", Vector2i(3, 3), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(0, -1), Vector2i(1, -1), Vector2i(2, -1), Vector2i(-1, -1)]),
	all_runes.LARGE_CON_RUNE : RuneInfo.new("Large Constitution Rune", Vector2i(4, 3), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(-1, 0), Vector2i(-2, 0), Vector2i(-3, 0), Vector2i(0, -1), Vector2i(1, -1)]),
	all_runes.TINY_RES_RUNE : RuneInfo.new("Tiny Resiliance Rune", Vector2i(0, 1), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0)]),
	all_runes.SMALL_RES_RUNE : RuneInfo.new("Small Resiliance Rune", Vector2i(1, 1), [Vector2i(0, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1)]),
	all_runes.MED_RES_RUNE : RuneInfo.new("Medium Resiliance Rune", Vector2i(2, 1), [Vector2i(0, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(-2, 0), Vector2i(-1, -1)]),
	all_runes.ALL_RES_RUNE : RuneInfo.new("All Resiliance Rune", Vector2i(3, 1), [Vector2i(0, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(-2, 0), Vector2i(-1, -1), Vector2i(-2, 1)]),
	all_runes.LARGE_RES_RUNE : RuneInfo.new("Large Resiliance Rune", Vector2i(4, 1), [Vector2i(0, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(-2, 0), Vector2i(-1, -1), Vector2i(2, 0), Vector2i(2, 1)]),
	all_runes.TINY_INT_RUNE : RuneInfo.new("Tiny Intelligence Rune", Vector2i(0, 2), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0)]),
	all_runes.SMALL_INT_RUNE : RuneInfo.new("Small Intelligence Rune", Vector2i(1, 2), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1)]),
	all_runes.MED_INT_RUNE : RuneInfo.new("Medium Intelligence Rune", Vector2i(2, 2), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1), Vector2i(-1, -1), Vector2i(-1, 1)]),
	all_runes.ALL_INT_RUNE : RuneInfo.new("All Intelligence Rune", Vector2i(3, 2), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1), Vector2i(-1, -1), Vector2i(-1, 1), Vector2i(1, 1)]),
	all_runes.LARGE_INT_RUNE : RuneInfo.new("Large Intelligence Rune", Vector2i(4, 2), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1), Vector2i(-1, -1), Vector2i(-1, 1), Vector2i(1, 1), Vector2i(0, 1)]),
	all_runes.TINY_SPD_RUNE : RuneInfo.new("Tiny Speed Rune", Vector2i(0, 7), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(0, 1)]),
	all_runes.SMALL_SPD_RUNE : RuneInfo.new("Small Speed Rune", Vector2i(1, 7), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(1, 0), Vector2i(1, -1)]),
	all_runes.MED_SPD_RUNE : RuneInfo.new("Medium Speed Rune", Vector2i(2, 7), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(1, 0), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)]),
	all_runes.ALL_SPD_RUNE : RuneInfo.new("All Speed Rune", Vector2i(3, 7), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(1, -2), Vector2i(2, -1)]),
	all_runes.LARGE_SPD_RUNE : RuneInfo.new("Large Speed Rune", Vector2i(4, 7), [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(1, 0), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1), Vector2i(-2, 0), Vector2i(2, 0)]),
	all_runes.TINY_LCK_RUNE : RuneInfo.new("Tiny Luck Rune", Vector2i(0, 0), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0)]),
	all_runes.SMALL_LCK_RUNE : RuneInfo.new("Small Luck Rune", Vector2i(1, 0), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(-1, 0), Vector2i(-1, -1)]),
	all_runes.MED_LCK_RUNE : RuneInfo.new("Medium Luck Rune", Vector2i(2, 0), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(1, 2), Vector2i(-1, -2)]),
	all_runes.ALL_LCK_RUNE : RuneInfo.new("All Luck Rune", Vector2i(3, 0), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, -1), Vector2i(1, 2), Vector2i(0, -2), Vector2i(0, 2), Vector2i(1, -2)]),
	all_runes.LARGE_LCK_RUNE : RuneInfo.new("Large Luck Rune", Vector2i(4, 0), [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(1, 2), Vector2i(-1, -2), Vector2i(0, 2), Vector2i(0, -2)]),
}
var rune_attr_dict : Dictionary[all_runes, AttrRuneInfo] = {
	all_runes.TINY_MGT_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.MIGHT),
	all_runes.SMALL_MGT_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.MIGHT),
	all_runes.MED_MGT_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.MIGHT),
	all_runes.LARGE_MGT_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.MIGHT),
	all_runes.TINY_POT_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.POTENCY),
	all_runes.SMALL_POT_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.POTENCY),
	all_runes.MED_POT_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.POTENCY),
	all_runes.LARGE_POT_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.POTENCY),
	all_runes.TINY_CON_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.CONSTITUTION),
	all_runes.SMALL_CON_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.CONSTITUTION),
	all_runes.MED_CON_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.CONSTITUTION),
	all_runes.LARGE_CON_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.CONSTITUTION),
	all_runes.TINY_RES_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.RESILIENCE),
	all_runes.SMALL_RES_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.RESILIENCE),
	all_runes.MED_RES_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.RESILIENCE),
	all_runes.LARGE_RES_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.RESILIENCE),
	all_runes.TINY_INT_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.INTELLIGENCE),
	all_runes.SMALL_INT_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.INTELLIGENCE),
	all_runes.MED_INT_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.INTELLIGENCE),
	all_runes.LARGE_INT_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.INTELLIGENCE),
	all_runes.TINY_SPD_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.SPEED),
	all_runes.SMALL_SPD_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.SPEED),
	all_runes.MED_SPD_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.SPEED),
	all_runes.LARGE_SPD_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.SPEED),
	all_runes.TINY_LCK_RUNE : AttrRuneInfo.new(1, AttrRune.attr_type.LUCK),
	all_runes.SMALL_LCK_RUNE : AttrRuneInfo.new(2, AttrRune.attr_type.LUCK),
	all_runes.MED_LCK_RUNE : AttrRuneInfo.new(3, AttrRune.attr_type.LUCK),
	all_runes.LARGE_LCK_RUNE : AttrRuneInfo.new(4, AttrRune.attr_type.LUCK),
}
var rune_all_attr_dict : Dictionary[all_runes, AttrRune.attr_type] = {
	all_runes.ALL_MGT_RUNE : AttrRune.attr_type.MIGHT,
	all_runes.ALL_POT_RUNE : AttrRune.attr_type.POTENCY,
	all_runes.ALL_CON_RUNE : AttrRune.attr_type.CONSTITUTION,
}

func generate_rune(rune_key : all_runes):
	var new_rune : Rune = Rune.new()
	new_rune.popup_text = rune_info_dict[rune_key].rune_name
	new_rune.frame = rune_info_dict[rune_key].frame
	new_rune.shape = rune_info_dict[rune_key].shape
	if rune_attr_dict.has(rune_key):
		var new_attr_rune : AttrRune = AttrRune.new()
		new_attr_rune.attribute_bonus = AttrBonus.new(rune_attr_dict[rune_key].value, new_rune.popup_text)
		new_attr_rune.effects_attr = rune_attr_dict[rune_key].attr_to_effect
		new_rune.add_child(new_attr_rune)
	RuneManager.drag_container.add_child(new_rune)
	RuneManager.grab_rune(new_rune)

func debug_generate_one_of_each():
	for rune_key : all_runes in rune_info_dict:
		generate_rune(rune_key)
