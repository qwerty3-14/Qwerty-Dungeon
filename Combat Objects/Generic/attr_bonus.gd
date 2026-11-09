extends Resource
class_name AttrBonus

signal value_changed(_old_value : int,  _new_value : int)

@export var value : int = 0
@export var source : String = ""

func _init(_value : int = 0, _source : String = ""):
	value = _value
	source = _source

func set_value(_value : int):
	if _value != value:
		value_changed.emit(value, _value)
		value = _value
