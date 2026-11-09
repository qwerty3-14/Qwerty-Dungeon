extends WeaponAttackEvent
class_name ChargeAttackEvent

@export var landing_pos : Vector2i

var attempted_hit : bool = false

func _init(attacker : CombatObject, target : CombatObject, _damage : Damage, _landing_pos : Vector2i) -> void:
	#wait_time = 0.5
	one_shot = true
	dependent_combat_objects.append(attacker)
	dependent_combat_objects.append(target)
	damage = _damage
	landing_pos = _landing_pos
	calculate_time()
	if target.has_node("Actor"):
			miss = not attacker.get_node("Actor").try_to_hit(target.get_node("Actor"))
	var watcher : TimerWatcher = TimerWatcher.new()
	watcher.activation_threshold = 0.5
	watcher.threshold_reached.connect(_on_timer_watcher_threshold_reached)
	add_child(watcher)


func calculate_time():
	var impact_pos : Vector2 = Globals.tile_to_pix_pos(landing_pos) + lerp(Vector2.ZERO,  (Globals.tile_to_pix_pos(dependent_combat_objects[1].tile_position) - Globals.tile_to_pix_pos(landing_pos)).normalized() * 16, sin(PI * 0.5))
	wait_time = 0.25 + (impact_pos - dependent_combat_objects[0].position).length() / 128

func _position_attacker():
	if time_left <= 0.25:
		if not attempted_hit:
			_on_timer_watcher_threshold_reached()
			attempted_hit = true
		dependent_combat_objects[0].position = Globals.tile_to_pix_pos(landing_pos) + lerp(Vector2.ZERO,  (Globals.tile_to_pix_pos(dependent_combat_objects[1].tile_position) - Globals.tile_to_pix_pos(landing_pos)).normalized() * 16, sin(PI * time_left / 0.5))
	else:
		var impact_pos : Vector2 = Globals.tile_to_pix_pos(landing_pos) + lerp(Vector2.ZERO,  (Globals.tile_to_pix_pos(dependent_combat_objects[1].tile_position) - Globals.tile_to_pix_pos(landing_pos)).normalized() * 16, sin(PI * 0.5))
		var prog : float = 1 - ((time_left - 0.25) / (wait_time - 0.25))
		dependent_combat_objects[0].position = lerp(Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position), impact_pos, prog)


func _on_charge_timeout() -> void:
	dependent_combat_objects[0].move_to(landing_pos)
	dependent_combat_objects[0].position_on_tile()
