@icon("uid://cj3pqq6miebuq")
class_name Action
extends APSpender

enum types {
	UNLABELED,
	BASIC_WEAPON_ATTACK,
	MODIFIED_WEAPON_ATTACK,
	MARTIAL_ART,
	ALCHEMY,
	FIRE_MAGIC,
	ELDER_MAGIC,
	METEOROLOGY
}

const END_ACTION_EVENT := preload("uid://br1ll51oid4w")

##emitted as the skill the action is attached to is clicked
signal used(_action : Action)
##emitted after combat main sets the current action
signal post_used_setup()
##emitted before the action is either canceled or completed succesfully, before any combat events play out caused by the action play out
signal inputs_done()
##emitted when the action is either canceled or completed succesfully
signal ended()
##emitted when the action is completed succesfully
signal finished()
signal cooldown_started(duration : int)
signal AI_used(_action : Action, _steps : Array)

signal tile_position_clicked(_tile_pos : Vector2i)
signal cursor_moved(_tile_pos : Vector2i, _in_bounds : bool)
signal AI_evalutation_in_progress(action : Action, _rivals : Array[CombatObject], _allies : Array[CombatObject])
signal debug_evalation_in_progress(_action : Action,  _evaluation : ActionTargetEvaluation)

@export var phase_cooldown : int
@export var type : types

var cooldown_counter : int = 0
var skill : Skill
var AI_evalutation_in_progress_SR : Array[ActionTargetEvaluation] = []
var debug_evalation_in_progress_SR : String = ""


func _ready() -> void:
	Globals.global_singletons_redied.connect(_on_global_singletons_redied)
	if get_parent() is Skill:
		skill = get_parent()
		skill.attached_to_hotbar_slot.connect(_on_attached_to_hotbar_slot)
		skill.removed_from_hotbar_slot.connect(_on_removed_from_hotbar_slot)
		skill.hover_hints_given.connect(_on_hover_hints_given)
		skill.hover_hints_removed.connect(_on_hover_hints_removed)
		skill.skill_clicked.connect(use)
		skill.aquired_by_actor.connect(_on_aquired_by_actor)
	else:
		push_error("Parent must be skill")

func _on_global_singletons_redied():
	Globals.global_singletons_redied.disconnect(_on_global_singletons_redied)

func _on_aquired_by_actor(actor : Actor):
	actor.actions.append(self)
	skill.checking_playable.connect(_on_show_playable.bind(actor))
	used.connect(Globals.combat_main._on_action_started)
	AI_used.connect(Globals.combat_main._on_action_started_by_AI)
	Globals.combat_main.phase_ending.connect(tick_cooldown)
	

func start_cooldown():
	if phase_cooldown != 0:
		cooldown_counter = phase_cooldown
		cooldown_started.emit(phase_cooldown)

func tick_cooldown():
	if cooldown_counter > 0:
		cooldown_counter -= 1

func reset_cooldown():
	cooldown_counter = 0
	cooldown_started.emit(0)

func use():
	Globals.combat_main.move_help_box_away_from(skill.combat_object_grandparent.tile_position)
	used.emit(self)

func cancel():
	start_end()
	
func finish():
	ended.connect(_on_finishing_end)
	start_end()

func start_end():
	var ce := END_ACTION_EVENT.instantiate()
	ce.timeout.connect(end.bind(ce))
	CombatEventManager.add_and_start_combat_event(ce)
	inputs_done.emit()

func emit_post_used_setup():
	post_used_setup.emit()

func _on_finishing_end():
	if phase_cooldown != 0:
		start_cooldown()
	spend_ap()
	ended.disconnect(_on_finishing_end)
	finished.emit()

func end(ce : CombatEvent):
	Globals.actions_menu.set_ap_cost(0)
	ended.emit()
	ce.timeout.disconnect(end.bind(ce))

func _on_tile_position_clicked(_tile_pos : Vector2i):
	tile_position_clicked.emit(_tile_pos)

func _on_cursor_tile_position_changed(_tile_pos : Vector2i, _in_bounds : bool):
	cursor_moved.emit(_tile_pos, _in_bounds)

func _on_attached_to_hotbar_slot(slot : SkillHotbarSlot):
	cooldown_started.connect(slot.set_cooldown)
	ended.connect(slot._on_action_ended)
	if cooldown_counter != 0:
		slot.set_cooldown(cooldown_counter)

func _on_removed_from_hotbar_slot(slot : SkillHotbarSlot):
	cooldown_started.disconnect(slot.set_cooldown)
	ended.disconnect(slot._on_action_ended)

func playable(actor : Actor) -> bool:
	return actor.cur_ap >= ap_cost and cooldown_counter == 0

func _on_show_playable(actor : Actor):
	if not playable(actor):
		skill.show_playable = false
	if Globals.combat_main.current_actor != actor or Globals.combat_main.battle_finished:
		skill.show_playable = false

func _on_hover_hints_given():
	if Globals.actions_menu:
		Globals.actions_menu.set_ap_cost(ap_cost)
	#Globals.over_room_renders.add_action_to_skill_info_panel(self)
	
func _on_hover_hints_removed():
	if Globals.actions_menu:
		Globals.actions_menu.set_ap_cost(0)

func AI_evaluate(_rivals : Array[CombatObject], _allies : Array[CombatObject]) -> Array[ActionTargetEvaluation]:
	AI_evalutation_in_progress_SR.clear()
	AI_evalutation_in_progress.emit(self, _rivals, _allies)
	return AI_evalutation_in_progress_SR

func AI_use(steps : Array):
	AI_used.emit(self, steps)

func debug_evalutation(evaluation : ActionTargetEvaluation) -> String:
	debug_evalation_in_progress_SR = ""
	debug_evalation_in_progress.emit(self, evaluation)
	return debug_evalation_in_progress_SR
