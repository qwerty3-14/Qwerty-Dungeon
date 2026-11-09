extends Node

signal combat_event_queue_finished()

#combat events
var curr_combat_event : CombatEvent
var combat_event_queue : Array[CombatEvent] = []


##Combat Event Methods
func remove_dependent_events(combat_object : CombatObject):
	#print(combat_event_queue)
	combat_event_queue = combat_event_queue.filter(func(event : CombatEvent): return not event.dependent_combat_objects.has(combat_object))
	#print(combat_event_queue)

func cancel_step_queue():
	combat_event_queue.clear()

func start_next_combat_event():
	if curr_combat_event:
		if curr_combat_event.timeout.is_connected(start_next_combat_event):
			curr_combat_event.timeout.disconnect(start_next_combat_event)
		curr_combat_event.queue_free()
	if combat_event_queue.size() > 0:
		Globals.combat_main.try_set_disable_turn_button(true)
		curr_combat_event = combat_event_queue[0]
		combat_event_queue.remove_at(0)
		curr_combat_event.start()
		curr_combat_event._started()
		curr_combat_event.timeout.connect(start_next_combat_event)
	else:
		Globals.combat_main.try_set_disable_turn_button(false)
		combat_event_queue_finished.emit()

func add_and_start_combat_event(combat_event : CombatEvent, immediatly : bool = false):
	add_child(combat_event)
	if immediatly:
		combat_event_queue.push_front(combat_event)
	else:
		combat_event_queue.append(combat_event)
	#print(combat_event_queue)
	if (not curr_combat_event) or curr_combat_event.is_queued_for_deletion():
		start_next_combat_event()

func add_and_start_combat_events(combat_events : Array[CombatEvent]):
	#print(combat_events)
	combat_event_queue.append_array(combat_events)
	#print(combat_event_queue)
	if not curr_combat_event or curr_combat_event.is_queued_for_deletion():
		start_next_combat_event()
