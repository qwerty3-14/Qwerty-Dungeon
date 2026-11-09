@icon("uid://b7l86hrhhu23x")
extends StatusEffect

@export var damage : Damage

func _on_ticked() -> void:
	parent.receive_damage(damage)


func _on_ready() -> void:
	description = "Receive " + str(damage) + " at the end of each phase"
