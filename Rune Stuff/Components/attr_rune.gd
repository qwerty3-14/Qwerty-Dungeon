extends Node
class_name AttrRune

enum attr_type {
	MIGHT,
	POTENCY,
	CONSTITUTION,
	RESILIENCE,
	INTELLIGENCE,
	SPEED,
	LUCK
}

@export var attribute_bonus : AttrBonus
@export var effects_attr : attr_type
var bonus : AttrBonus

var rune : Rune

func _ready() -> void:
	if get_parent() is Rune:
		bonus = attribute_bonus.duplicate(true)
		rune = get_parent()
		rune.equiped.connect(_on_rune_equiped)
		rune.unequiped.connect(_on_rune_unequiped)
		rune.popup_text = bonus.source
	else:
		printerr("Parent must be rune")

func get_attribute_from_actor(actor : Actor, type : attr_type) -> Attribute:
	match type:
		attr_type.MIGHT:
			return actor.might
		attr_type.POTENCY:
			return actor.potency
		attr_type.CONSTITUTION:
			return actor.constitution
		attr_type.RESILIENCE:
			return actor.resilience
		attr_type.INTELLIGENCE:
			return actor.intelligence
		attr_type.SPEED:
			return actor.speed
		attr_type.LUCK:
			return actor.luck
	return actor.might

func _on_rune_equiped(actor : Actor):
	get_attribute_from_actor(actor, effects_attr).add_bonus(bonus)

func _on_rune_unequiped(actor : Actor):
	get_attribute_from_actor(actor, effects_attr).remove_bonus(bonus)
