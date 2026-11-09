@icon("uid://dnek7w6qult2x")
extends Skill

func _on_ready():
	combat_object_grandparent.defense.add_base(1)
	combat_object_grandparent.warding.add_base(1)
