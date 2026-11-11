@icon("uid://bmb188xtsy7pj")
extends Skill

func _on_aquired_by_actor():
	combat_object_grandparent.flyer = true
