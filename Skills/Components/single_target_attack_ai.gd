extends Node
class_name SingleTargetAI

signal ready_to_use_action(_tile_pos : Vector2i)
signal about_to_score(rival : CombatObject)
signal update_my_damage()

@export var attack_name : String = "Attack"

var skill_parent : Skill
var action : Action
var target_range : TargetRange
var about_to_score_damage_modifier_SR : float = 0
var about_to_score_ap_modifier_SR : int = 0
var about_to_score_multiplier_SR : float = 1
var damage : Damage

func setup(_skill_parent : Skill, _action : Action, _target_range : TargetRange):
	skill_parent = _skill_parent
	action = _action
	target_range = _target_range
	action.AI_evalutation_in_progress.connect(_on_action_AI_evaluation)
	action.AI_used.connect(_on_action_AI_used)
	action.debug_evalation_in_progress.connect(_on_action_debug_evalation_in_progress)
	if skill_parent.actor_parent:
		_on_aquired_by_actor(skill_parent.actor_parent)
	else:
		skill_parent.aquired_by_actor.connect(_on_aquired_by_actor)

func send_update_my_damage_signal():
	update_my_damage.emit()
	

func _on_aquired_by_actor(_actor : Actor):
	update_my_damage.emit()
	_actor.potency.changed.connect(send_update_my_damage_signal)
	_actor.might.changed.connect(send_update_my_damage_signal)

func _on_action_AI_evaluation(_action : Action, _rivals : Array[CombatObject], _allies : Array[CombatObject]):
	#var astar_grid = Globals.a_star_manager.grid_to_use(skill_parent.combat_object_grandparent)
	#evauluate for each rival
	for rival : CombatObject in _rivals:
		target_range.find_tiles(rival.tile_position)
		var shortest_path : PackedVector2Array
		var shortest_path_length = -1
		
		#already in range?
		if target_range.tiles.has(skill_parent.combat_object_grandparent.tile_position):
			append_evalutation(_action, rival)
		else:
			#find the shortest path to attack this rival
			target_range.remove_occupied()
			for tile : Vector2i in target_range.tiles:
				#target_range.highlight_tiles()
				var path : PackedVector2Array = Globals.a_star_manager.find_path_for_combat_object(skill_parent.combat_object_grandparent, tile)
				#var path : PackedVector2Array = astar_grid.get_point_path(skill_parent.combat_object_grandparent.tile_position, tile)
				if path.size() > 0:
					if shortest_path_length == -1 or path.size() < shortest_path_length:
						shortest_path_length = path.size()
						shortest_path = path
			
			if shortest_path and shortest_path.size() <= (skill_parent.actor_parent.cur_ap - _action.ap_cost) + skill_parent.actor_parent.cur_mp:
				append_evalutation(_action, rival, shortest_path, max(0, shortest_path_length - skill_parent.actor_parent.cur_mp))

func append_evalutation(_action : Action, rival : CombatObject, path : PackedVector2Array = [], extra_ap : int = 0):
	var action_target_eval : ActionTargetEvaluation = ActionTargetEvaluation.new()
	action_target_eval.action = _action
	var damage_est : Damage = damage.clone()
	damage_est.modify_against(rival)
	about_to_score_damage_modifier_SR = 0
	about_to_score_ap_modifier_SR = 0
	about_to_score_multiplier_SR = 1
	about_to_score.emit(rival)
	action_target_eval.score = ((rival.score_damage(damage_est) / rival.health.current) + about_to_score_damage_modifier_SR) / (action.ap_cost + extra_ap + about_to_score_ap_modifier_SR)
	action_target_eval.score *= about_to_score_multiplier_SR
	action_target_eval.settings = [path, rival]
	_action.AI_evalutation_in_progress_SR.append(action_target_eval)

func _on_action_AI_used(_action : Action, steps : Array):
	if steps.size() == 2:
		var move_path : PackedVector2Array = steps[0]
		var target : CombatObject = steps[1]
		if move_path.size() > 0:
			var move_events : Array[CombatEvent] = Globals.a_star_manager.generate_move_events(skill_parent.combat_object_grandparent, move_path)
			move_events[-1].timeout.connect(_on_AI_steps_finished.bind(target.tile_position))
			Globals.combat_main.set_actor_acted(true)
			CombatEventManager.add_and_start_combat_events(move_events)
		else:
			_on_AI_steps_finished(target.tile_position)
	else:
		printerr("expected 2 steps")

func _on_AI_steps_finished(_tile_pos : Vector2i):
	#target_range.setup_attack_range(skill_parent.combat_object_grandparent.tile_position)
	target_range.find_tiles(skill_parent.combat_object_grandparent.tile_position)
	target_range.find_targets()
	#print(str(skill_parent.combat_object_grandparent.tile_position) + ", " + str(_tile_pos))
	
	ready_to_use_action.emit(_tile_pos)

func _on_action_debug_evalation_in_progress(_action : Action, _evaluation : ActionTargetEvaluation):
	if _evaluation.settings[0].size() > 0:
		var move_to : Vector2i = _evaluation.settings[0][-1]
		var target : CombatObject = _evaluation.settings[1]
		action.debug_evalation_in_progress_SR = "Move to " + str(move_to) + " to " + attack_name.to_lower() + " " + target.name + " (Score: " + str(_evaluation.score) + ")"
	else:
		var target : CombatObject = _evaluation.settings[1]
		action.debug_evalation_in_progress_SR = attack_name + " " + target.name + " (Score: " + str(_evaluation.score) + ")"
