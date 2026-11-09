extends Node

signal about_to_apply_status(status : StatusEffect, target : CombatObject)
signal status_been_applied()

@export var status_effect : PackedScene
@export var resistable : bool = false

func _ready() -> void:
	if get_parent() is StatusEffect:
		get_parent().get_parent().queued_weapon_attack.connect(_on_parent_queued_weapon_attack)
		status_been_applied.connect(get_parent().reduce_duration)
		if get_parent().get_parent().has_node("Actor"):
			var actor : Actor = get_parent().get_parent().get_node("Actor")
			actor.preparing_forecast.connect(_on_actor_preparing_forecast)
	else:
		printerr("parent must be StatusEffect")

func _on_parent_queued_weapon_attack(event : WeaponAttackEvent):
	event.target_been_hit.connect(_on_target_been_hit)
	event.timeout.connect(_on_timeout.bind(event))

func _on_target_been_hit(target : CombatObject):
	var status := status_effect.instantiate()
	about_to_apply_status.emit(status, target)
	if resistable:
		if get_parent().actor:
			target.apply_status_effect_resistable(status, get_parent().actor.potency.value)
	else:
		target.apply_status_effect(status)
	status_been_applied.emit()
	Globals.actions_menu.reload_status()

func _on_timeout(event : WeaponAttackEvent):
	event.target_been_hit.disconnect(_on_target_been_hit)
	event.timeout.disconnect(_on_timeout.bind(event))

func _on_actor_preparing_forecast(forecast_lines : Array[ForecastLine]):
	for line : ForecastLine in forecast_lines:
		line.status_icons.append(status_effect.instantiate().icon)

#func _on_tree_exiting() -> void:
#	get_parent().get_parent().queued_weapon_attack.disconnect(_on_parent_queued_weapon_attack)
