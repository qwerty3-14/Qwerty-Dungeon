@icon("uid://nl7c5thcn0ax")
extends Skill

func _on_aquired_by_actor():
	combat_object_grandparent.defense.add_base(2)
