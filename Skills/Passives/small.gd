@icon("uid://cubr5mdairphc")
extends Skill

var bonus : AttrBonus = AttrBonus.new(15, "Small")

func _on_aquired_by_actor():
	actor_parent.health.maximum -= 10
	actor_parent.dodge_chance.add_bonus(bonus)
	
