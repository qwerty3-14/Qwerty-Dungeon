extends Resource
class_name  Attribute

signal value_changed(amount : int)

@export var base_value : int = 0

var value : int = 0
var bonuses : Array[AttrBonus] = []

func _init(_base : int) -> void:
	add_base(_base)

func calculate_value():
	value = base_value
	for bonus : AttrBonus in bonuses:
		value += bonus.value
	value_changed.emit(value)

func add_base(amt : int):
	base_value += amt
	value += amt
	value_changed.emit(value)
	#calculate_value()

func add_bonus(bonus : AttrBonus):
	bonuses.append(bonus)
	value += bonus.value
	value_changed.emit(value)
	bonus.value_changed.connect(_on_bonus_changed)
	#calculate_value()

func remove_bonus(bonus : AttrBonus):
	if bonuses.has(bonus):
		value -= bonus.value
		bonuses.erase(bonus)
		value_changed.emit(value)
		bonus.value_changed.disconnect(_on_bonus_changed)

func colored_text() -> String:
	if value == base_value:
		return str(value)
	var color_code : String
	if value > base_value:
		color_code = "2cb92c"
	if value < base_value:
		color_code = "821d30"
	return "[color=" + color_code + "]" + str(value) + "[/color]"

func _on_bonus_changed(_old_value : int, _new_value : int):
	value += _new_value - _old_value
