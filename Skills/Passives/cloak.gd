@icon("uid://dl2ihqxkh44g0")
extends Skill

func _on_aquired_by_actor():
	combat_object_grandparent.defense.add_base(1)
	combat_object_grandparent.warding.add_base(1)
