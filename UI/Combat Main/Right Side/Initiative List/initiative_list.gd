extends ColorRect

const INITIATIVE_PORTRAIT := preload("uid://dbic8y5202ji8")
const SHRINKING_SPACER := preload("uid://bd7ov5o2v1j3m")
const EXPANDING_SPACER := preload("uid://wjvb8j7ufl5g")
const REARANGMENT_EVENT := preload("uid://gp8ks1a2mkj5")
const PORTAIT_SIZE_X : int = 43
const PORTAIT_SIZE_Y : int = 27
const PIN_SIZE_Y = 5

var list : Array[SmallInitiativePortrait] = []
var pin_pos : int = 0

func set_actor_list(actor_combat_object_list : Array[CombatObject]):
	for obj : CombatObject in actor_combat_object_list:
		var actor : Actor = obj.get_node("Actor")
		var i_p : SmallInitiativePortrait = INITIATIVE_PORTRAIT.instantiate()
		i_p.update_visuals(actor)
		%VBoxContainer.add_child(i_p)
		list.append(i_p)
	%DelayPin.move_to_front()
	pin_pos = list.size()

func end_turn():
	remove_turn(0)
	#%VBoxContainer.get_children()[0].remove()

func delay_turn():
	if not %DelayPin.activated:
		%DelayPin.activate()
	pin_pos -= 1
	move_portrait(0, pin_pos)

func move_portrait(from_index : int, to_index : int):
	var path : Path2D = Path2D.new()
	%VBoxContainer.add_child(path)
	var curve : Curve2D = Curve2D.new()
	curve.add_point(Vector2(PORTAIT_SIZE_X * 0.5, index_to_y(from_index)))
	curve.add_point(Vector2(PORTAIT_SIZE_X * -0.5, index_to_y(from_index)))
	curve.add_point(Vector2(PORTAIT_SIZE_X * -0.5, index_to_y(to_index)))
	curve.add_point(Vector2(PORTAIT_SIZE_X * 0.5, index_to_y(to_index)))
	path.curve = curve
	var path_follow : PathFollow2D = PathFollow2D.new()
	path_follow.rotates = false
	path.add_child(path_follow)
	add_shrinker(from_index)
	var expander : ColorRect = add_expander(to_index)
	list[from_index].reparent(path_follow)
	var rearange_event : IntiativeRearangmentEvent = REARANGMENT_EVENT.instantiate()
	rearange_event.path_follows.append(path_follow)
	rearange_event.timeout.connect(_on_rearange_event_finished.bind(from_index, to_index, expander))
	#rearange_event.timeout.connect(reconnect_portrait.bind(from_index, to_index))
	#rearange_event.timeout.connect(expander.queue_free)
	#rearange_event.timeout.connect(Globals.combat_main.update_current_combatant)
	#rearange_event.timeout.connect(check_pin)
	CombatEventManager.add_and_start_combat_event(rearange_event)

func reconnect_portrait(from_index : int, to_index : int):
	var portrait : SmallInitiativePortrait = list[from_index]
	list.remove_at(from_index)
	list.insert(to_index, portrait)
	#expecting an error once it moves to front
	portrait.reparent(%VBoxContainer)
	if to_index == pin_pos:
		%VBoxContainer.move_child(portrait, %DelayPin.get_index() + 1)
	else:
		%VBoxContainer.move_child(portrait, list[to_index - 1].get_index() + 1)
	check_pin()

func move_portrait_index(from_index : int, to_index : int):
	var portrait : SmallInitiativePortrait = list[from_index]
	list.remove_at(from_index)
	list.insert(to_index, portrait)

func index_to_y(index : int):
	if index >= pin_pos and %DelayPin.activated:
		return index * PORTAIT_SIZE_Y + PIN_SIZE_Y
	return index * PORTAIT_SIZE_Y

func remove_turn(index : int):
	add_shrinker(index)
	list[index].remove()
	list.remove_at(index)
	pin_pos -= 1
	check_pin()

func add_shrinker(index : int) -> ColorRect:
	var spacer := SHRINKING_SPACER.instantiate()
	list[index].add_sibling(spacer)
	return spacer


func add_expander(index : int) -> ColorRect:
	var spacer := EXPANDING_SPACER.instantiate()
	if index == pin_pos:
		%DelayPin.add_sibling(spacer)
	else:
		list[index].add_sibling(spacer)
	return spacer

func check_pin():
	if pin_pos <= 0:
		%DelayPin.deactivate()

func clear_list():
	for i : int in range(list.size()):
		list[i].remove()
	list.clear()
	pin_pos = 0
	%DelayPin.deactivate()

func _on_mouse_exited() -> void:
	Globals.cursor_manager.disable_cursor()

func _on_rearange_event_finished(from_index : int, to_index : int, expander : ColorRect):
	reconnect_portrait(from_index, to_index)
	expander.queue_free()
	Globals.combat_main.update_current_combatant()
