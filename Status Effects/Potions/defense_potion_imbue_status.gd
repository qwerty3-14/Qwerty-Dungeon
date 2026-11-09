@icon("uid://buikc74xwldfu")
extends StatusEffect

func _on_ready() -> void:
	description = "The next " + str(duration) + " weapon attacks inflict 4 defense"
