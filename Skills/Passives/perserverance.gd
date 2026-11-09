@icon("uid://byka60xdeoet0")
extends Skill

var res_bonus : AttrBonus = AttrBonus.new(6, "Perserverance")
var giving_bonus : bool = false
var previus_bonus : bool = false

func _on_ready():
	combat_object_grandparent.health.health_changed.connect(_on_health_changed)

func _on_health_changed(_health : int):
	giving_bonus = float(_health) / combat_object_grandparent.health.maximum < 0.5
	if giving_bonus != previus_bonus:
		if giving_bonus:
			actor_parent.resilience.add_bonus(res_bonus)
		else:
			actor_parent.resilience.remove_bonus(res_bonus)
