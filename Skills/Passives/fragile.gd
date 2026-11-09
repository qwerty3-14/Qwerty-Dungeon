@icon("uid://djfrf3hpcr4tr")
extends Skill

func _on_aquired_by_actor():
	actor_parent.health.maximum -= 16
	actor_parent.phase_ap -= 2
