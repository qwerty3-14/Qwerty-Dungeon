extends Node
class_name WeaponAttackDamage

signal preparing_forecast(forecast_lines : Array[ForecastLine])

@export var damage_type : Damage.Type = Damage.Type.PIERCING
var actor : Actor
var repeats : int = 0
var bonus_damage : int = 0
var bonus_damage_multiplier : float = 1

func _ready() -> void:
	var ancestor : Node = get_parent()
	while (not ancestor is Skill):
		ancestor = ancestor.get_parent()
	var skill : Skill = ancestor
	skill.aquired_by_actor.connect(_on_aquired_by_actor)
	#actor = ancestor
	#preparing_forecast.connect(actor._on_weapon_attack_preparing_forecast)

func _on_aquired_by_actor(_actor : Actor):
	actor = _actor
	preparing_forecast.connect(actor._on_weapon_attack_preparing_forecast)

func create_forecast(target : CombatObject):
	if actor:
		var forecast : ForecastLine = ForecastLine.new()
		var damage = Damage.new(roundi((actor.might.value + bonus_damage) * bonus_damage_multiplier), damage_type, null, actor)
		var hit_chance : int = 100
		if target.has_node("Actor"):
			hit_chance = actor.calculate_hit_chance_against(target.get_node("Actor"))
		damage.modify_against(target)
		forecast.damage_instances.append(damage)
		forecast.chance = hit_chance
		forecast.repeats = repeats
		var forecast_lines : Array[ForecastLine] = [forecast]
		preparing_forecast.emit(forecast_lines)
		Globals.over_room_renders.action_forecast(target.tile_position, [forecast])
