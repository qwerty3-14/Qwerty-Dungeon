extends Control
class_name CombatMain


signal phase_ending()
signal phase_starting()
signal phase_zero_starting(phase_zero_actor_cos : Array[CombatObject])

const CHARACTER_MENUS := preload("uid://bgpbbxceqfsfg")
const END_TURN_EVENT := preload("uid://b35vd3fu6d2q")

@export var room : Room


#current turn
var current_actor_combat_object : CombatObject
var current_actor : Actor
var actor_acted : bool = false

#lists
var actor_combat_object_list : Array[CombatObject]
var delayed_actor_combat_objects : Array[CombatObject]
var playable_actors : Array[Actor] = []
var evil_actors : Array[Actor] = []



#misc
var combat_objects : Array[CombatObject] = []
var current_phase : int = 0
var temp_preview : bool = false
var battle_finished : bool = false

var action_is_active : bool = false
var active_action : Action

var char_menu : CharacterMenus

##Common Methods
func _ready() -> void:
	if PlayerStorage.players.size() == 0:
		PlayerStorage.emergency_load()
	Globals.combat_main = self
	Globals.cursor_manager = %CursorManager
	Globals.a_star_manager = %AStarManager
	Globals.over_room_renders = %OverRoomRenders
	Globals.actions_menu = %ActionsMenu
	
	Globals.send_singletons_ready_signal()
	MetaCombat.send_first_stage_loaded_signal(self)
	start_combat()
	
	if not char_menu:
		char_menu = CHARACTER_MENUS.instantiate()
		char_menu.combat_main = self
		char_menu.visible = false
		add_sibling.call_deferred(char_menu)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 2 and event.is_released():
		#print(action_is_active)
		if action_is_active:
			cancel_action()
	if(event.is_action("Debug Combat End")):
		win()

##Editor connected signals
func _on_end_turn_button_pressed() -> void:
	if actor_acted:
		end_turn()
	else:
		delay_turn()

func _on_room_region_mouse_exited() -> void:
	%CursorManager.disable_cursor()


func _on_cursor_manager_cursor_tile_position_changed(_position: Vector2i, _in_bounds: bool) -> void:
	if _in_bounds:
		move_help_box_away_from(_position)
	if action_is_active:
		%OverRoomRenders.clear_movement()
	elif _in_bounds:
		if tile_occupied(_position):
			var combat_object : CombatObject = combat_object_at_tile(_position)
			if combat_object != current_actor_combat_object and combat_object.has_node("Actor"):
				%ActionsMenu.load_actor(combat_object.get_node("Actor"))
				%OverRoomRenders.highlight_movement_range(combat_object.get_node("Actor"))
			temp_preview = true
		elif temp_preview:
			if current_actor:
				%ActionsMenu.load_actor(current_actor)
				if current_actor.alignment == Globals.alignment.PLAYABLE:
					%OverRoomRenders.highlight_movement_range(current_actor)
				else:
					%OverRoomRenders.clear_movement()
			temp_preview = false
		if current_actor and current_actor.alignment == Globals.alignment.PLAYABLE and CombatEventManager.combat_event_queue.size() == 0:
			%AStarManager.calculate_path_for_actor(current_actor_combat_object, current_actor, _position, _in_bounds)
	else:
		%AStarManager.empty_path()


func _on_menu_button_pressed() -> void:
	open_char_menu(false)

func _on_combat_end_popup_on_continue() -> void:
	open_char_menu(true)

##Script connected signals
func _on_current_co_move(_pos : Vector2i):
	%AStarManager.empty_path()

func _on_action_started(action : Action):
	action_is_active = true
	active_action = action
	%CursorManager.tile_position_clicked.connect(active_action._on_tile_position_clicked)
	%CursorManager.cursor_tile_position_changed.connect(active_action._on_cursor_tile_position_changed)
	active_action.finished.connect(finish_action)
	active_action.inputs_done.connect(_on_action_inputs_done)
	%ActionsMenu.disable_all_skills()
	action.emit_post_used_setup()

func _on_action_started_by_AI(action : Action, _steps : Array):
	action_is_active = true
	active_action = action
	active_action.finished.connect(finish_action)

func _on_action_inputs_done():
	if active_action:
		%CursorManager.tile_position_clicked.disconnect(active_action._on_tile_position_clicked)
		%CursorManager.cursor_tile_position_changed.disconnect(active_action._on_cursor_tile_position_changed)
		active_action.inputs_done.disconnect(_on_action_inputs_done)
	%OverRoomRenders.clear_forecast()
	remove_help_text()

##Return Methods
func tile_occupied(location : Vector2i) -> bool:
	return combat_objects.any(func(co : CombatObject): return co.tile_position == location)

func combat_object_at_tile(location : Vector2i) -> CombatObject:
	return combat_objects[combat_objects.find_custom(func(co : CombatObject): return co.tile_position == location)]

##setup Methods
func add_actor_to_lists(actor : Actor):
	match actor.alignment:
		Globals.alignment.PLAYABLE:
			playable_actors.append(actor)
		Globals.alignment.EVIL:
			evil_actors.append(actor)

##Order
func start_combat():
	#print("Combat Started")
	#print(MetaCombat.combat_objet_entered_combat.get_connections())
	current_phase = 0
	
	combat_objects = room.get_combat_objects()
	%GridToggleButton.pressed.connect(room.toggle_grid)
	for co : CombatObject in combat_objects:
		#print(co.name)
		MetaCombat.send_entered_combat_signal(co)
		if co.has_node("Actor"):
			var actor : Actor = co.get_node("Actor")
			add_actor_to_lists(actor)
			if actor.alignment == Globals.alignment.PLAYABLE:
				actor.heal_and_reset_cooldowns()
	if room.start_tip:
		print(room.start_tip)
		#%TipLabel.text = room.start_tip
		%TipPopup.dialog_text = room.start_tip
		%TipPopup.popup_centered_clamped()
	%AStarManager.astar_update_tiles()
	phase_zero_starting.emit(actor_combat_object_list)
	%InitiativeList.set_actor_list(actor_combat_object_list)
	MetaCombat.send_combat_started_signal()
	update_current_combatant()

func start_next_phase():
	current_phase += 1
	%PhaseLabel.text = "Phase " + str(current_phase)
	setup_initiative()
	for actor : CombatObject in actor_combat_object_list:
		actor.get_node("Actor").refresh_ap_and_mov()
	update_current_combatant()
	phase_starting.emit()

func end_current_phase():
	phase_ending.emit()

func end_turn():
	%InitiativeList.end_turn()
	if actor_combat_object_list.size() > 0:
		actor_combat_object_list.remove_at(0)
		var event : CombatEvent = END_TURN_EVENT.instantiate()
		event.timeout.connect(update_current_combatant)
		CombatEventManager.add_and_start_combat_event(event)
		#update_current_combatant()
	elif delayed_actor_combat_objects.size() > 0:
		delayed_actor_combat_objects.remove_at(0)
		var event : CombatEvent = END_TURN_EVENT.instantiate()
		event.timeout.connect(update_current_combatant)
		CombatEventManager.add_and_start_combat_event(event)
		#update_current_combatant()

func delay_turn():
	if actor_combat_object_list.size() <= 0:
		printerr("Should not be able to delay if the un delayed actor_combat_object_list is empty")
	delayed_actor_combat_objects.push_front(current_actor_combat_object)
	%InitiativeList.delay_turn()
	actor_combat_object_list.remove_at(0)
	if CombatEventManager.combat_event_queue_finished.is_connected(current_actor.AI):
		CombatEventManager.combat_event_queue_finished.disconnect(current_actor.AI)

func game_over():
	battle_end()
	%CombatEndPopup.game_over_popup()

func win():
	battle_end()
	%CombatEndPopup.victory_popup()

func battle_end():
	%ActionsMenu.reinable_all_skills()
	battle_finished = true
	update_current_combatant()
	%InitiativeList.clear_list()
	actor_combat_object_list.clear()
	delayed_actor_combat_objects.clear()
	%AStarManager.empty_path()

##Turn Management
func setup_initiative():
	for obj : CombatObject in combat_objects:
		if obj.has_node("Actor"):
			actor_combat_object_list.append(obj)
	if actor_combat_object_list.size() > 0:
		actor_combat_object_list.shuffle()
		actor_combat_object_list.sort_custom(func(a : Node2D, b : Node2D): return a.get_node("Actor").initiative > b.get_node("Actor").initiative)
	%InitiativeList.set_actor_list(actor_combat_object_list)

func update_current_combatant():
	if current_actor_combat_object:
		if current_actor_combat_object.moved.is_connected(_on_current_co_move):
			current_actor_combat_object.moved.disconnect(_on_current_co_move)
	if current_actor:
		if CombatEventManager.combat_event_queue_finished.is_connected(current_actor.AI):
			CombatEventManager.combat_event_queue_finished.disconnect(current_actor.AI)
	
	if battle_finished:
		current_actor_combat_object = null
		current_actor = null
	else:
		if actor_combat_object_list.size() > 0:
			current_actor_combat_object = actor_combat_object_list[0]
			set_actor_acted(false)
			current_actor_setup()
		elif delayed_actor_combat_objects.size() > 0:
			current_actor_combat_object = delayed_actor_combat_objects[0]
			set_actor_acted(true)
			current_actor_setup()
		else:
			end_current_phase()
			start_next_phase()

func current_actor_setup():
	current_actor = current_actor_combat_object.get_node("Actor")
	%ActionsMenu.load_actor(current_actor)
	current_actor_combat_object.moved.connect(_on_current_co_move)
	if current_actor.alignment != Globals.alignment.PLAYABLE:
		current_actor.AI()
		if CombatEventManager.combat_event_queue.size() > 0:
			CombatEventManager.combat_event_queue_finished.connect(current_actor.AI)
		%OverRoomRenders.clear_movement()
	else:
		%OverRoomRenders.highlight_movement_range(current_actor)
	try_set_disable_turn_button(false)


##Action Methods
func cancel_action():
	active_action.cancel()
	end_action()

func finish_action():
	set_actor_acted(true)
	end_action()

func end_action():
	active_action.finished.disconnect(finish_action)
	
	if %CursorManager.tile_position_clicked.is_connected(active_action._on_tile_position_clicked):
		%CursorManager.tile_position_clicked.disconnect(active_action._on_tile_position_clicked)
		%CursorManager.cursor_tile_position_changed.disconnect(active_action._on_cursor_tile_position_changed)
		active_action.inputs_done.disconnect(_on_action_inputs_done)
	active_action = null
	action_is_active = false
	%ActionsMenu.reinable_all_skills()
	#fix properly later
	if current_actor and current_actor.alignment == Globals.alignment.PLAYABLE:
		%OverRoomRenders.highlight_movement_range(current_actor)

##Button Check
func try_set_disable_turn_button(disable : bool):
	if current_actor and current_actor.alignment != Globals.alignment.PLAYABLE:
		%EndTurnButton.disabled = true
	else:
		%EndTurnButton.disabled = disable

func set_actor_acted(state : bool):
	actor_acted = state
	if state:
		%EndTurnButton.text = "End Turn"
	else:
		%EndTurnButton.text = "Delay Turn"

##Other Methods
func next_stage():
	#PlayerStorage.retreive_players()
	while combat_objects.size() > 0:
		remove_combat_object(combat_objects[0])
	%CombatEndPopup.reset()
	room.queue_free()
	room = load(room.next_room_path).instantiate()
	%SubViewport.add_child(room)
	battle_finished = false
	start_combat()


func open_char_menu(between_battle : bool):
	if not char_menu:
		char_menu = CHARACTER_MENUS.instantiate()
		char_menu.combat_main = self
		add_sibling(char_menu)
	char_menu.visible = true
	if between_battle:
		char_menu.set_between_battle_mode()
	else:
		char_menu.set_middle_of_battle_mode()
	visible = false

func give_help_text(text : String):
	%HelpBox.text = text
	%HelpBox.visible = true

func remove_help_text():
	%HelpBox.visible = false

func remove_combat_object(combat_object : CombatObject):
	if current_actor_combat_object == combat_object:
		%InitiativeList.end_turn()
		actor_combat_object_list.remove_at(0)
		if actor_combat_object_list.size() > 0:
			update_current_combatant()
		else:
			end_current_phase()
			start_next_phase()
	elif actor_combat_object_list.has(combat_object):
		%InitiativeList.remove_turn(actor_combat_object_list.find(combat_object))
		actor_combat_object_list.erase(combat_object)
	elif delayed_actor_combat_objects.has(combat_object):
		%InitiativeList.remove_turn(actor_combat_object_list.size() + delayed_actor_combat_objects.find(combat_object))
		
	if combat_object.has_node("Actor"):
		evil_actors.erase(combat_object.get_node("Actor"))
		playable_actors.erase(combat_object.get_node("Actor"))
	combat_objects.erase(combat_object)
	if PlayerStorage.players.has(combat_object):
		PlayerStorage.retreive_player(combat_object)
	else:
		combat_object.queue_free()
	if playable_actors.size() == 0:
		game_over()
	if evil_actors.size() == 0:
		win()

func move_help_box_away_from(tile_pos : Vector2i):
	if tile_pos.y < 8:
		%HelpBoxContainer.position.y = 160
		#%HelpBoxContainer.set_anchors_preset(Control.PRESET_BOTTOM_WIDE, true)
	else:
		%HelpBoxContainer.position.y = 0
		#%HelpBoxContainer.set_anchors_preset(Control.PRESET_TOP_WIDE, true)
