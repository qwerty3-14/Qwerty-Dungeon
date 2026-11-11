extends Node
class_name BaseWeaponAttack

signal preparing_forecast(forecast_lines : Array[ForecastLine])
signal about_to_score(rival : CombatObject, target_ai : SingleTargetAI)

const WEAPON_ATTACK_DAMAGE = preload("uid://c1lvhgeg2s3xs")


@export var action : Action
@export var target_range : TargetRange
@export var damage_type : Damage.Type = Damage.Type.PIERCING
@export var bonus_damage : int = 0
@export var bonus_damage_multiplier : float = 1
@export var repeats : int = 0

var skill_parent : Skill
var weapon_attack_damage : WeaponAttackDamage

func _ready() -> void:
	weapon_attack_damage = WEAPON_ATTACK_DAMAGE.instantiate()
	weapon_attack_damage.damage_type = damage_type
	weapon_attack_damage.repeats = repeats
	weapon_attack_damage.bonus_damage = bonus_damage
	weapon_attack_damage.bonus_damage_multiplier = bonus_damage_multiplier
	add_child(weapon_attack_damage)
	weapon_attack_damage.preparing_forecast.connect(emit_preparing_forcast)
	if action:
		action.used.connect(_on_action_used)
		action.tile_position_clicked.connect(_on_tile_position_clicked)
		action.cursor_moved.connect(_on_cursor_moved)
		$WeaponAttackAI.setup(get_parent(), action, target_range, damage_type, repeats)
		$WeaponAttackAI.about_to_score.connect(_on_ai_about_to_score)
	if get_parent() is Skill:
		skill_parent = get_parent()
		skill_parent.need_info_panel_extras.connect(_on_need_info_panel_extras)

func _on_ai_about_to_score(rival : CombatObject, target_ai : SingleTargetAI):
	about_to_score.emit(rival, target_ai)

func _on_need_info_panel_extras(ino_panel : InfoPanel):
	ino_panel.load_range(target_range)

func emit_preparing_forcast(forecast_lines : Array[ForecastLine]):
	preparing_forecast.emit(forecast_lines)
	

func _on_tile_position_clicked(_tile_pos : Vector2i):
	if try_to_attack_position(_tile_pos):
		action.finish()

func _on_cursor_moved(_tile_pos : Vector2i, _in_bounds : bool):
	if _in_bounds and target_range.can_target_position(_tile_pos):
		weapon_attack_damage.create_forecast(Globals.combat_main.combat_object_at_tile(_tile_pos))
	else:
		Globals.over_room_renders.clear_forecast()


func _on_action_used(_action: Action) -> void:
	target_range.setup_attack_range(skill_parent.combat_object_grandparent.tile_position)


func try_to_attack_position(_tile_pos : Vector2i, immediatly : bool = false) -> bool:
	if target_range.can_target_position(_tile_pos):
		var co_attacker : CombatObject = skill_parent.actor_parent.get_parent()
		var amt : int = roundi((skill_parent.actor_parent.might.value + bonus_damage) * bonus_damage_multiplier)
		var wae := WeaponAttackEvent.new(co_attacker, Globals.combat_main.combat_object_at_tile(_tile_pos), Damage.new(amt, damage_type, action, skill_parent.actor_parent), repeats)
		
		CombatEventManager.add_and_start_combat_event(wae, immediatly)
		return true
	return false
