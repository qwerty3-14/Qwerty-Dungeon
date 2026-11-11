extends Node

const DAMAGE_BASED : String = "Damage is based on "

#func damage(damage : Damage) -> String:
#	return "[color=" + Damage.Type_color_code() + "]" + str(damage.amount) + " " + Damage.Type_name() + " damage[/color]"

func skill_damage_help(uses_mgt : bool = true, modifier : int = 0, multiplier : float = 0) -> String:
	var attribute : String = "Potency"
	if uses_mgt:
		attribute = "Might"
	if modifier != 0:
		return "Damage = " + attribute + " +" + str(modifier)
	if multiplier != 0:
		return "Damage = " + attribute + " x" + str(multiplier)
	return "Damage = " + attribute

func skill_chance_help(multiplier : int = 1) -> String:
	if multiplier == 1:
		return "Chance = Luck %"
	return "Chance = Luck x" + str(multiplier) + "%"

func skill_range(r : float) -> String:
	return "Range: " + str(r)

func generic_actor_skill_desc(a_description : String, _actor : Actor) -> String:
	a_description = a_description.replace("<PD>", "[color=" + Damage.color_code[Damage.Type.PIERCING] + "] "+ str(_actor.might.value) +" piercing damage[/color]")
	a_description = a_description.replace("<PD-2>", "[color=" + Damage.color_code[Damage.Type.PIERCING] + "] "+ str(_actor.might.value-2) +" piercing damage[/color]")
	a_description = a_description.replace("<CD>", "[color=" + Damage.color_code[Damage.Type.CRUSHING] + "] "+ str(_actor.might.value) +" crushing damage[/color]")
	a_description = a_description.replace("<SD>", "[color=" + Damage.color_code[Damage.Type.SLASHING] + "] "+ str(_actor.might.value) +" slashing damage[/color]")
	if _actor.default_weapon_attack:
		if _actor.default_weapon_attack.repeats > 0:
			a_description = a_description.replace("<VD>", "[color=" + Damage.color_code[_actor.default_weapon_attack.damage_type] + "] "+ str(_actor.might.value + _actor.default_weapon_attack.bonus_damage) + " " + Damage.names[_actor.default_weapon_attack.damage_type] + " damage[/color] " + str(1 + _actor.default_weapon_attack.repeats) + " times")
		else:
			a_description = a_description.replace("<VD>", "[color=" + Damage.color_code[_actor.default_weapon_attack.damage_type] + "] "+ str(_actor.might.value + _actor.default_weapon_attack.bonus_damage) + " " + Damage.names[_actor.default_weapon_attack.damage_type] + " damage[/color]")
	a_description = a_description.replace("<ED>", "[color=" + Damage.color_code[Damage.Type.ELDER] + "] "+ str(_actor.potency.value) +" elder damage[/color]")
	a_description = a_description.replace("<ED-6>", "[color=" + Damage.color_code[Damage.Type.ELDER] + "] "+ str(_actor.potency.value-6) +" elder damage[/color]")
	a_description = a_description.replace("<FD>", "[color=" + Damage.color_code[Damage.Type.FIRE] + "] "+ str(_actor.potency.value) +" fire damage[/color]")
	a_description = a_description.replace("<LD>", "[color=" + Damage.color_code[Damage.Type.ELECTRIC] + "] "+ str(_actor.potency.value) +" electric damage[/color]")
	
	a_description = a_description.replace("<L>",  str(_actor.luck.value) + "% Chance")
	a_description = a_description.replace("<L2>",  str(_actor.luck.value * 2) + "% Chance")
	a_description = a_description.replace("<L3>",  str(_actor.luck.value * 3) + "% Chance")
	a_description = a_description.format({"Actor" : _actor.character_name})
	return a_description
