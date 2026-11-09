extends Resource
class_name Damage


enum Type {
	DIRECT, ##ignores defense and resistance
	CRUSHING, ##physical damage
	PIERCING, ##physical damage
	SLASHING, ##physical damage
	FIRE, ##magical damage
	ELDER, ##magical damage
	POISON, ##magical damage
	ELECTRIC ##magical damage
	}

@export var amount : int = 0
@export var type : Type
var mitigated : bool = false
var action_source : Action
var actor_source : Actor

static var color_code : Dictionary[Type, String] = {
	Type.DIRECT : "821d30",
	Type.CRUSHING : "818b8e",
	Type.PIERCING : "818b8e",
	Type.SLASHING : "818b8e",
	Type.FIRE : "c56742",
	Type.ELDER : "a63c97",
	Type.POISON : "2cb92c",
	Type.ELECTRIC : "eee52a",
}
static var names : Dictionary[Type, String] = {
	Type.DIRECT : "direct",
	Type.CRUSHING : "crushing",
	Type.PIERCING : "piercing",
	Type.SLASHING : "slashing",
	Type.FIRE : "fire",
	Type.ELDER : "elder",
	Type.POISON : "poison",
	Type.ELECTRIC : "electric",
}

func _init(_amount : int = 0, _type : Type = Type.DIRECT, _action_source : Action = null, _actor_source : Actor = null):
	amount = _amount
	type = _type
	action_source = _action_source
	actor_source = _actor_source

func _to_string() -> String:
	return "[color=" + damage_type_color_code() + "]" + str(amount) + " " + damage_type_name() + " damage[/color]"

func colored_number() -> String:
	return "[color=" + damage_type_color_code() + "]" + str(amount)+ "[/color]"

func deep_copy() -> Damage:
	return Damage.new(amount, type)

func damage_type_color_code() -> String:
	return color_code[type]

func damage_type_color() -> Color:
	return Color(damage_type_color_code())

func damage_type_name() -> String:
	match type:
		Type.DIRECT:
			return "direct"
		Type.CRUSHING:
			return "crushing"
		Type.PIERCING:
			return "piercing"
		Type.SLASHING:
			return "slashing"
		Type.FIRE:
			return "fire"
		Type.ELDER:
			return "elder"
		Type.POISON:
			return "poison"
		Type.ELECTRIC:
			return "poison"
	return "unknown"

func damage_physical():
	return type == Type.CRUSHING or type == Type.PIERCING or type == Type.SLASHING

func damage_magical():
	return not (damage_physical() or type == Type.DIRECT)

func modify_against(target : CombatObject):
	if damage_physical():
		amount -= target.defense.value
	if damage_magical():
		amount -= target.warding.value
	target.extra_damage_modification(self)
	mitigated = true

func from_spell() -> bool:
	if action_source:
		return action_source.type == Action.types.FIRE_MAGIC or action_source.type == Action.types.ELDER_MAGIC
	return false

func clone() -> Damage:
	var new_damage : Damage = Damage.new(amount, type, action_source, actor_source)
	new_damage.mitigated = mitigated
	return new_damage
