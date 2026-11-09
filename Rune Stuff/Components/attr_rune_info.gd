extends Resource
class_name AttrRuneInfo

var value : int
var attr_to_effect : AttrRune.attr_type

func _init(_value : int, _attr_to_effect : AttrRune.attr_type) -> void:
	value = _value
	attr_to_effect = _attr_to_effect
