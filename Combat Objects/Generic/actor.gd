class_name Actor
extends Node

const HEALTH = preload("uid://dnq41o300iq4y")
const BASE_HP = 30
const HP_FROM_CON = 3
const MAX_ATRRIBUTE = 30
const MAX_MAX_HP = Actor.BASE_HP + Actor.HP_FROM_CON * Actor.MAX_ATRRIBUTE

signal ap_changed(value : int)
signal mp_changed(value : int)
signal preparing_forecast(forecast_lines : Array[ForecastLine])
signal default_weapon_attack_updated(weapon_attack : WeaponAttack)
signal finished_ready()
signal learned_skill(_skill : Skill)

@export var actor_info : ActorInfo

@onready var portrait : Texture2D = actor_info.portrait
@onready var icon : Texture2D = actor_info.icon
@onready var character_name : String = actor_info.character_name
@onready var combat_class : String = actor_info.combat_class

@export_category("AI")
@export var prefered_range_max : float = 1
@export var prefered_range_min : float = 0

@export_category("Misc")
@export var alignment : Globals.alignment = Globals.alignment.EVIL
@export var hotbar_skills : Dictionary[int, Skill]


@onready var might : Attribute = Attribute.new(actor_info.base_might) ##Effects damage with weapon attacks
@onready var potency : Attribute = Attribute.new(actor_info.base_potency) ##Makes spells more powerful
@onready var constitution : Attribute = Attribute.new(actor_info.base_constitution) ##Increases max healt, max ap, and makes it harder to be moved against your will
@onready var resilience : Attribute = Attribute.new(actor_info.base_resilience) ##Weakens or prevents negetive status effects, increases healing after battle
@onready var intelligence : Attribute = Attribute.new(actor_info.base_intelligence) ##increases inititive and xp gain
@onready var speed : Attribute = Attribute.new(actor_info.base_speed) ##odd levels increase mp, even  levels increase inititive
@onready var luck : Attribute = Attribute.new(actor_info.base_luck) ##increases hit chance and dogdge chance with weapon attacks, effects chance based skills
@onready var luck_dodge_bonus : AttrBonus = AttrBonus.new(0, "Luck")
@onready var dodge_chance : Attribute = Attribute.new(0)
@onready var luck_hit_bonus : AttrBonus = AttrBonus.new(0, "Luck")
@onready var hit_chance : Attribute = Attribute.new(100)

var max_ap : int = 5
var cur_ap : int = 0
var phase_ap : int = 6
var max_mp : int = 0
var cur_mp : int = 0
var initiative : int = 0
var sub_initative : int = 0
var health : Health
var actions : Array[Action] = []
var default_weapon_attack : WeaponAttack

var co_parent : CombatObject

var blinded : bool = false


func _ready() -> void:
	dodge_chance.add_bonus(luck_dodge_bonus)
	hit_chance.add_bonus(luck_hit_bonus)
	might.value_changed.connect(_attri_value_changed.bind(might))
	potency.value_changed.connect(_attri_value_changed.bind(potency))
	constitution.value_changed.connect(_attri_value_changed.bind(constitution))
	resilience.value_changed.connect(_attri_value_changed.bind(resilience))
	intelligence.value_changed.connect(_attri_value_changed.bind(intelligence))
	speed.value_changed.connect(_attri_value_changed.bind(might))
	luck.value_changed.connect(_attri_value_changed.bind(might))
	health = HEALTH.instantiate()
	if get_parent() is CombatObject:
		co_parent = get_parent()
		co_parent.add_child.call_deferred(health)
		co_parent.health = health
		health.killed.connect(co_parent.remove_me)
		co_parent.moved.connect(_on_co_parent_moved)
	else:
		printerr("Actor needs CombatObject parent")
	update_stats()
	finished_ready.emit()

func _attri_value_changed(_amt : int, _attr : Attribute):
	update_stats()

func update_stats():
	@warning_ignore("integer_division")
	max_ap = 5 + ((constitution.value + 1) / 2)
	@warning_ignore("integer_division")
	max_mp = ((speed.value + 1) / 2)
	@warning_ignore("integer_division")
	initiative = intelligence.value + (speed.value / 2)
	
	health.maximum = BASE_HP + HP_FROM_CON * constitution.value
	health.current = health.maximum
	
	luck_dodge_bonus.set_value(luck.value * 3)
	luck_hit_bonus.set_value(luck.value * 3)
	
	if get_parent() is CombatObject:
		get_parent().weight = constitution.value

func learn_skill(_skill : Skill):
	add_child(_skill)
	learned_skill.emit(_skill)

func _on_co_parent_moved(_pos : Vector2i):
	pass

func AI():
	var rivals : Array[CombatObject] = []
	match alignment:
		Globals.alignment.EVIL:
			for actor : Actor in Globals.combat_main.playable_actors:
				rivals.append(actor.get_parent())
		Globals.alignment.PLAYABLE:
			for actor : Actor in Globals.combat_main.evil_actors:
				rivals.append(actor.get_parent())
	var allies : Array[CombatObject] = []
	match alignment:
		Globals.alignment.EVIL:
			for actor : Actor in Globals.combat_main.evil_actors:
				allies.append(actor.get_parent())
		Globals.alignment.PLAYABLE:
			for actor : Actor in Globals.combat_main.playable_actors:
				allies.append(actor.get_parent())
	if rivals.size() > 0:
		var playable_actions : Array[Action] = actions.filter(func(action : Action) : return action.playable(self))
		if playable_actions.size() > 0:
			var action_target_evals : Array[ActionTargetEvaluation] = []
			for action : Action in playable_actions:
				action_target_evals.append_array(action.AI_evaluate(rivals, allies))
			if action_target_evals.size() > 0:
				action_target_evals.sort_custom(func(should_be_before : ActionTargetEvaluation, other : ActionTargetEvaluation): return should_be_before.score > other.score)
				print(character_name + " " + combat_class + ": evauluation")
				action_target_evals.map(func(eval : ActionTargetEvaluation): eval.debug_text())
				print(" ")
				action_target_evals[0].action.AI_use(action_target_evals[0].settings)
			else:
				AI_move_toward_rivals(rivals)
		else:
			AI_move_toward_rivals(rivals)
	else:
		AI_end_or_delay_my_turn()

func AI_move_toward_rivals(rivals : Array[CombatObject]):
	#rivals.sort_custom(func(should_be_before : CombatObject, other : CombatObject): return (should_be_before.tile_position - co_parent.tile_position).length_squared() < (other.tile_position - co_parent.tile_position).length_squared())
	#var closest_rival : CombatObject = rivals[0]
	#print(closest_rival.name)
	var free_movement : int = cur_mp + max(0, phase_ap - (max_ap - cur_ap))
	var prefered_tiles : Array[Vector2i] = [] #Globals.los_tiles_in_range(closest_rival.tile_position, prefered_range_max, prefered_range_min)
	for rival : CombatObject in rivals:
		prefered_tiles.append_array(Globals.los_tiles_in_range(rival.tile_position, prefered_range_max, prefered_range_min))
	#print("prefered tiles: " + str(prefered_tiles))
	if prefered_tiles.size() == 0 or prefered_tiles.has(co_parent.tile_position):
		AI_end_or_delay_my_turn()
	else:
		var filtered_tiles : Array[Vector2i] = Globals.a_star_manager.standable_tiles_for_combat_object(co_parent, prefered_tiles)
		filtered_tiles = filtered_tiles.filter(func(tile : Vector2i): return Globals.a_star_manager.find_path_for_combat_object(co_parent, tile).size() > 0)
		#print("filtered tiles: " + str(prefered_tiles))
		#var go_to : Vector2i = Globals.closest_tile(co_parent.tile_position, filtered_tiles)
		#print("closest tile: " + str((go_to)))
		#var path : PackedVector2Array = []
		var go_to : Vector2i = Vector2i.ZERO
		var min_length : int = -1
		for tile : Vector2i in filtered_tiles:
			var calc_path : PackedVector2Array = Globals.a_star_manager.find_path_for_combat_object(co_parent, tile)
			if min_length == -1 or calc_path.size() < min_length:
				min_length = calc_path.size()
				go_to = tile
		if min_length != -1:
			var path : PackedVector2Array = Globals.a_star_manager.find_path_for_combat_object(co_parent, go_to, free_movement)
			if path.size() == 0:
				AI_end_or_delay_my_turn()
			else:
				Globals.a_star_manager.travel_path(co_parent, path)
		else:
			AI_end_or_delay_my_turn()
			

func AI_end_or_delay_my_turn():
	if Globals.combat_main.actor_acted:
		Globals.combat_main.end_turn()
	else:
		Globals.combat_main.delay_turn()

func spend_ap(amount : int):
	cur_ap -= amount
	cur_ap = max(0, cur_ap)
	ap_changed.emit(cur_ap)
	#if Globals.combat_main.current_actor == self and alignment == Globals.alignment.PLAYABLE:
	#	Globals.over_room_renders.highlight_movement_range(self)
	
func spend_mp(amount : int):
	cur_mp -= amount
	cur_mp = max(0, cur_mp)
	mp_changed.emit(cur_mp)

func refresh_ap_and_mov():
	cur_ap += phase_ap
	cur_ap = min(cur_ap, max_ap)
	cur_mp = max_mp

#func hit_chance() -> int:
#	return 100 + luck.value * 3

#func dodge_chance() -> int:
#	return luck.value * 3

func calculate_hit_chance_against(target : Actor) -> int:
	return min(100, hit_chance.value - target.dodge_chance.value)

func try_to_hit(target : Actor) -> bool:
	return calculate_hit_chance_against(target) > Globals.rng.randi_range(0, 99)

func _on_weapon_attack_preparing_forecast(forecast_lines : Array[ForecastLine]):
	preparing_forecast.emit(forecast_lines)

func set_default_weapon_attack(weapon_attack : WeaponAttack):
	default_weapon_attack = weapon_attack
	default_weapon_attack_updated.emit(default_weapon_attack)

func heal_and_reset_cooldowns():
	health.heal(constitution.value * 3)
	for action : Action in actions:
		action.reset_cooldown()
