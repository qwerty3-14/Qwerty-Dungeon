extends Resource
class_name RuneInfo

var rune_name : String
var frame : Vector2i
var shape : Array[Vector2i]

func _init(_rune_name : String, _frame : Vector2i, _shape : Array[Vector2i]):
	rune_name = _rune_name
	frame = _frame
	shape = _shape
