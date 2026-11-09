@icon("uid://by2triyshvu5w")
extends StatusEffect


func _on_ready() -> void:
	description = "The next " + str(duration) + " weapon attacks inflict weaken, reducing mgt by 4"
