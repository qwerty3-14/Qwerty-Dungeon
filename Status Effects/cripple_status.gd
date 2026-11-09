@icon("uid://bovujxsew4xsb")
extends StatusEffect



func _on_ready() -> void:
	phase_started.connect(_on_phase_started)
	description = "Won't gain mp next phase"

func _on_phase_started():
	actor.cur_mp = 0
	expired.emit()
	queue_free()
