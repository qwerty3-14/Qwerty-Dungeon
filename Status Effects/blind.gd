@icon("uid://b1synotntvvd1")
extends StatusEffect
class_name Blind

const ICON := preload("uid://b1synotntvvd1")

var bonus : AttrBonus = AttrBonus.new(-15, "Blind")

func _init() -> void:
	icon = ICON
	display_name = "blind"
	name = "blind"
	duration = 3
	ready.connect(_on_ready)
	tree_exiting.connect(_on_tree_exiting)

func _on_ready():
	description = "Range of most skills reduced to 1\n-15%hit chance"
	if actor:
		actor.hit_chance.add_bonus(bonus)
		actor.blinded = true

func _on_tree_exiting():
	if actor:
		actor.hit_chance.remove_bonus(bonus)
		actor.blinded = true
