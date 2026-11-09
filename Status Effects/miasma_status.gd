@icon("uid://bhirkq3ao7i07")
extends StatusEffect

@export var damage : Damage

func _on_ticked() -> void:
	parent.receive_damage(damage)
	%CloudParticles.global_position = parent.global_position
	%CloudParticles.emitting = true
	%EffectTimer.start()


func _on_ready() -> void:
	description = "Receive " + str(damage) + " at the end of each phase"


func _on_effect_timer_timeout() -> void:
	%CloudParticles.emitting = false
