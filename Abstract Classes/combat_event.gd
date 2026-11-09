class_name CombatEvent
extends Timer

var dependent_combat_objects : Array[CombatObject] = []

func  _ready() -> void:
	pass

##virtual method meant to be overwritten. Called immediatly after this combat event starts
func _started():
	pass
