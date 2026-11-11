extends CombatEvent
class_name KilledEvent


func _init(victim : CombatObject) -> void:
	wait_time = 0.5
	one_shot = true
	dependent_combat_objects.append(victim)
	timeout.connect(_on_timeout)
	var watcher : TimerWatcher = TimerWatcher.new()
	watcher.threshold_reached.connect(_on_start)
	add_child(watcher)

func _process(_delta: float) -> void:
	if dependent_combat_objects[0] and not dependent_combat_objects[0].is_queued_for_deletion():
		dependent_combat_objects[0].position = Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position) + 2 * Vector2.RIGHT * sin(6 * PI *time_left / wait_time)


func _on_timeout() -> void:
	dependent_combat_objects[0].emit_killed()
	Globals.combat_main.remove_combat_object(dependent_combat_objects[0])
	Globals.a_star_manager.astar_update_tiles()

func _on_start():
	CombatEventManager.remove_dependent_events(dependent_combat_objects[0])
	if dependent_combat_objects[0].flyer:
		dependent_combat_objects[0].rotation = 0
