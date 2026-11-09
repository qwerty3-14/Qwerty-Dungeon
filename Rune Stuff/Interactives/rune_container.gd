extends Control

const RUNE_GRABBER := preload("uid://cpdpj3120f68f")
var rune : Rune

func _ready() -> void:
	if get_children().size() > 0:
		rune = get_child(0)
	#var grabber :  RuneGrabber = RUNE_GRABBER.instantiate()
