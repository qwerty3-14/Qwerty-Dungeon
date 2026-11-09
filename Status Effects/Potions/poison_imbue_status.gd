@icon("uid://cm18ax84da1qh")
extends StatusEffect

func _on_ready() -> void:
	description = "The next " + str(duration) + " weapon attacks deals " + str(Damage.new(actor.potency.value, Damage.Type.POISON)) + " and inflict 5 turns of poison"
	if actor:
		actor.preparing_forecast.connect(_on_actor_preparing_forecast)

func _on_actor_preparing_forecast(forecast_lines : Array[ForecastLine]):
	for line : ForecastLine in forecast_lines:
		line.damage_instances.append(Damage.new(actor.potency.value, Damage.Type.POISON))


func _on_imbue_about_to_apply_status(status: StatusEffect, target : CombatObject) -> void:
	var damage : Damage = Damage.new(actor.potency.value, Damage.Type.POISON)
	if parent.has_node("Actor"):
		damage.actor_source = parent.get_node("Actor")
	target.receive_damage(damage)
	status.damage = damage
